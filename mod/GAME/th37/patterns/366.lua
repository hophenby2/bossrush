-- 离线展开：b366.xna；事件均已编译为Lua条件和调用。
return {id="366",total=600,centerAvailable=true,center={315,175,0,0,0,0},centerEvents=function(o,t,R)
if t==(1) then R.move(o,250,370,160,180) end
if t==(301) then R.move(o,250,370,160,180) end
end,globalEvents=function(c,t,R)

end,types={{188,188,60,60,30,30,0,0},{436,126,60,60,30,30,0,0},{374,126,60,60,30,30,0,0},{312,126,60,60,30,30,0,0},{188,64,60,60,30,30,0,0},{126,64,60,60,30,30,0,0},{64,436,60,60,30,30,0,0},{64,374,60,60,30,30,0,0},{126,312,60,60,30,30,0,0},{126,250,60,60,30,30,0,0},{126,188,60,60,30,30,0,0},{126,126,60,60,30,30,0,0},{436,64,60,60,30,30,0,0},{374,64,60,60,30,30,0,0},{312,64,60,60,30,30,0,0},{250,64,60,60,30,30,0,0},{64,64,60,60,30,30,0,0},{436,2,60,60,30,30,0,0},{374,2,60,60,30,30,0,0},{312,2,60,60,30,30,0,0},{250,2,60,60,30,30,0,0},{188,2,60,60,30,30,0,0},{126,2,60,60,30,30,0,0},{64,2,60,60,30,30,0,0},{2,436,60,60,30,30,0,0},{2,374,60,60,30,30,0,0},{2,312,60,60,30,30,0,0},{2,250,60,60,30,30,0,0},{2,188,60,60,30,30,0,0},{2,126,60,60,30,30,0,0},{2,64,60,60,30,30,0,0},{2,2,60,60,30,30,0,0},{64,312,60,60,30,30,0,0},{64,250,60,60,30,30,0,0},{64,188,60,60,30,30,0,0},{64,126,60,60,30,30,0,0},{270,210,193,197,96,105,0,0},{270,407,193,197,96,105,0,0},{64,636,60,60,30,30,0,0},{2,676,60,60,30,30,0,0},{2,614,60,60,30,30,0,0},{2,552,60,60,30,30,0,0},{64,698,55,49,27,24,0,0},{64,552,46,41,23,20,0,0},{1,512,118,38,59,20,0,0},{120,514,103,97,51,85,0,0},{64,595,39,39,20,20,10,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=120,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=21,["t"]=40,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=400,["type"]=178,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222.0,0,1,"正比",22) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=420,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=21,["t"]=40,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=400,["type"]=175,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222.0,0,1,"正比",22) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=261,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.75,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(6+math.floor(t/28)*28) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(13+math.floor(t/28)*28) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(20+math.floor(t/28)*28) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(27+math.floor(t/28)*28) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",90.0,0,1,"正比",60) end
if t==(242) then R.change(o,"sonspeedd",0.0,50.0,1,"正比",121) end
if t==(240) then R.change(o,"yscale",1.0,0,0,"正比",1) end
if t==(240) then R.change(o,"sonspeed",3.0,0,0,"正比",30) end
if t==(241) then R.change(o,"sonspeedd",270.0,100.0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=192,["y"]=288,["begin"]=120,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=11,["t"]=4,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=140,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=6,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.015,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=331,["y"]=156,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=273,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.75,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,1,"正比",60) end
if t==(60) then R.change(o,"sonspeedd",90.0,0,0,"正比",1) end
if t==(60) then R.change(o,"yscale",1.0,0,0,"正比",1) end
if t==(61) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(60) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=331,["y"]=156,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=274,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.75,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,1,"正比",60) end
if t==(60) then R.change(o,"sonspeedd",90.0,0,0,"正比",1) end
if t==(60) then R.change(o,"yscale",1.0,0,0,"正比",1) end
if t==(61) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(120) then R.change(o,"sonspeedd",270.0,10.0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(60) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(121) then R.change(o,"head",0.0,360.0,1,"正比",120) end
if t==(120) then R.change(o,"sonspeed",3.0,0,0,"正比",1) end
if t==(121) then R.change(o,"alpha",1.0,0,0,"正比",121) end
if t==(121) then R.change(o,"sonspeed",0.01,0,0,"正比",121) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=192,["y"]=320,["begin"]=145,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=160,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=17,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=192,["y"]=384,["begin"]=117,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=11,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=201,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.6,0.1,0,"正比",1) end
if t==(1+math.floor(t/120)*120) then R.change(o,"head",360.0,0,1,"正比",120) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=301,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=233,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.75,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(6+math.floor(t/28)*28) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(13+math.floor(t/28)*28) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(20+math.floor(t/28)*28) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(27+math.floor(t/28)*28) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",90.0,0,2,"正比",60) end
if t==(242) then R.change(o,"sonspeedd",0.0,50.0,1,"正比",121) end
if t==(240) then R.change(o,"yscale",1.0,0,0,"正比",1) end
if t==(240) then R.change(o,"sonspeed",3.0,0,0,"正比",30) end
if t==(241) then R.change(o,"sonspeedd",270.0,100.0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=308,["y"]=156,["begin"]=301,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=273,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.75,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,2,"正比",60) end
if t==(60) then R.change(o,"sonspeedd",90.0,0,0,"正比",1) end
if t==(60) then R.change(o,"yscale",1.0,0,0,"正比",1) end
if t==(61) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(60) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=308,["y"]=156,["begin"]=301,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=274,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.75,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90.0,0,2,"正比",60) end
if t==(60) then R.change(o,"sonspeedd",90.0,0,0,"正比",1) end
if t==(60) then R.change(o,"yscale",1.0,0,0,"正比",1) end
if t==(61) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(120) then R.change(o,"sonspeedd",270.0,10.0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(60) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(121) then R.change(o,"head",0.0,360.0,1,"正比",120) end
if t==(120) then R.change(o,"sonspeed",3.0,0,0,"正比",1) end
if t==(121) then R.change(o,"alpha",1.0,0,0,"正比",121) end
if t==(121) then R.change(o,"sonspeed",0.01,0,0,"正比",121) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=224,["y"]=288,["begin"]=420,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=11,["t"]=4,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=140,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=4,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.015,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=224,["y"]=384,["begin"]=417,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=11,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=201,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.6,0.1,0,"正比",1) end
if t==(1+math.floor(t/120)*120) then R.change(o,"head",360.0,0,2,"正比",120) end
end},
{["id"]=11,["parentid"]=1,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=192,["y"]=416,["begin"]=110,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=170,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=50,["type"]=271,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=2,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/121)*120) then R.change(o,"alpha",1.0,0,0,"正比",50) end
if t==(1+math.floor(t/121)*120) then R.change(o,"head",0.0,360.0,1,"正比",50) end
end},
{["id"]=12,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=224,["y"]=416,["begin"]=410,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=170,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=50,["type"]=271,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=2,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/121)*120) then R.change(o,"alpha",1.0,0,0,"正比",50) end
if t==(1+math.floor(t/121)*120) then R.change(o,"head",0.0,360.0,1,"正比",50) end
end},
{["id"]=13,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=224,["y"]=320,["begin"]=445,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=160,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=19,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=14,["parentid"]=1,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=192,["y"]=352,["begin"]=145,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=15,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=17,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=15,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=224,["y"]=352,["begin"]=445,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=15,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=19,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end}
}}
