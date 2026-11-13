return {["id"]="345",["total"]=640,["order"]=1,["centerAvailable"]=true,["center"]={480,260,0,0,0,0},["types"]={{0,0,70,70,35,34,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{0,70,70,70,35,32,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{0,140,70,70,35,29,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{0,210,70,70,35,28,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{0,280,70,70,35,32,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{0,350,70,70,35,36,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{0,420,70,70,35,45,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{70,0,70,70,35,34,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{70,70,70,70,35,32,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{70,140,70,70,35,29,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{70,210,70,70,35,28,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{70,280,70,70,35,32,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{70,350,70,70,35,36,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{70,420,70,70,35,45,5,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{0,0,100,100,50,50,0,0,1,0,0,0,0,0,0,"quan"},{140,0,127,100,63,50,16,0,3,5,0,0,0,0,0,"3BOSS_fw2"},{140,300,127,100,63,50,16,0,4,5,0,0,0,0,0,"3BOSS_fw2"},{267,0,127,100,63,50,16,0,3,5,0,0,0,0,0,"3BOSS_fw2"},{267,300,127,100,63,50,16,0,4,5,0,0,0,0,0,"3BOSS_fw2"},{140,0,127,100,63,50,16,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{267,0,127,100,63,50,16,0,1,0,0,0,0,0,0,"3BOSS_fw2"},{0,0,200,200,100,100,0,0,5,2,0,0,0,0,0,"niangaobaozha"},{200,0,200,200,100,100,0,0,5,2,0,0,0,0,0,"niangaobaozha"}},centerEvents=function(o,t,R)
if t==(580) then R.move(o,false,420,540,190,240) end
if t==(20) then R.sound("stage3float") end
if t==(100) then R.sound("stage3float") end
if t==(180) then R.sound("stage3float") end
if t==(290) then R.sound("stage3float") end
if t==(370) then R.sound("stage3float") end
if t==(450) then R.sound("stage3float") end
if t==(61) then R.state(o,1) end
if t==(540) then R.state(o,0) end
end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["x"]=480,["y"]=328,["begin"]=1,["life"]=540,["halfw"]=400,["halfh"]=400,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=4,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"life",1200,0,0,"正比",1) end
if t>(1) then R.change(o,"Dispel",1,0,0,"正比",1) end
if t>(1) then R.change(o,"alpha",100,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=640,["y"]=520,["begin"]=73,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=11,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=150,["wscale"]=1,["hscale"]=1,["colorR"]=44,["colorG"]=133,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.18,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"sonspeed",3,0,0,"正比",1) end
if t==(1+math.floor(t/100)*100) then R.change(o,"sonspeedd",210,0,0,"正比",1) end
if t==(51+math.floor(t/100)*100) then R.change(o,"sonspeedd",330,0,0,"正比",1) end
if t==(51+math.floor(t/100)*100) then R.change(o,"sonspeed",3,0,0,"正比",1) end
if t==(1+math.floor(t/100)*100) then R.change(o,"alpha",33,0,0,"正比",33) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=200,["begin"]=31,["life"]=240,["fx"]=-99998,["fy"]=222,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=9,["fdirection"]=240,["fdirections"]={0.0,0.0},["range"]=145,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=74,["type"]=152,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.2,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/80)*80) then R.change(o,"fdirection",12,0,1,"正比",1) end
if t==(1+math.floor(t/80)*80) then R.change(o,"t",9,0,0,"正比",1) end
if t==(55+math.floor(t/80)*80) then R.change(o,"t",9999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(64) then R.change(o,"type",1,0,1,"正比",1) end
if t==(69) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15) then R.change(o,"wscale",0.1,0,1,"正弦",35) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",13) end
if t==(61) then R.change(o,"sonspeed",4.5,0,0,"正比",24) end
if t==(55) then R.change(o,"alpha",100,0,0,"正比",5) end
if t==(60) then R.change(o,"sonspeedd",230,0,0,"正比",1) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",13) end
if t==(57) then R.change(o,"hscale",1.13,0,0,"正比",6) end
if t==(15) then R.change(o,"hscale",0.1,0,2,"正弦",35) end
if t==(50) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(57) then R.change(o,"wscale",1.13,0,0,"正比",6) end
if t==(50) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(50) then R.change(o,"hscale",0.6,0,0,"正比",6) end
if t==(50) then R.change(o,"wscale",1.8,0,0,"正比",6) end
if t==(60) then R.change(o,"sonspeed",6,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=448,["y"]=264,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=11,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=148,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=155,["colorG"]=115,["colorB"]=115,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=-0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",-2.5,0,0,"正比",30) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=61,["life"]=580,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=21,["t"]=120,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=25,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=13,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/36)*36) then R.change(o,"hscale",0.06,0,2,"正弦",35) end
if t==(1+math.floor(t/36)*36) then R.change(o,"wscale",0.06,0,1,"正弦",35) end
if t==(1) then R.change(o,"sonspeed",1.8,0,0,"正比",13) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=380,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=120,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=29,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=148,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=608,["y"]=520,["begin"]=73,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=11,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=150,["wscale"]=1,["hscale"]=1,["colorR"]=44,["colorG"]=133,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.18,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"sonspeed",3,0,0,"正比",1) end
if t==(1+math.floor(t/100)*100) then R.change(o,"sonspeedd",330,0,0,"正比",1) end
if t==(51+math.floor(t/100)*100) then R.change(o,"sonspeedd",210,0,0,"正比",1) end
if t==(51+math.floor(t/100)*100) then R.change(o,"sonspeed",3,0,0,"正比",1) end
if t==(1+math.floor(t/100)*100) then R.change(o,"alpha",33,0,0,"正比",33) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=200,["begin"]=301,["life"]=240,["fx"]=-99998,["fy"]=222,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=9,["fdirection"]=300,["fdirections"]={0.0,0.0},["range"]=145,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=74,["type"]=159,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.2,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/80)*80) then R.change(o,"fdirection",12,0,2,"正比",1) end
if t==(1+math.floor(t/80)*80) then R.change(o,"t",9,0,0,"正比",1) end
if t==(55+math.floor(t/80)*80) then R.change(o,"t",99999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(64) then R.change(o,"type",1,0,1,"正比",1) end
if t==(69) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15) then R.change(o,"wscale",0.1,0,1,"正弦",35) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",13) end
if t==(61) then R.change(o,"sonspeed",4.5,0,0,"正比",24) end
if t==(60) then R.change(o,"sonspeed",6,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",310,0,0,"正比",1) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",13) end
if t==(57) then R.change(o,"hscale",1.13,0,0,"正比",6) end
if t==(15) then R.change(o,"hscale",0.1,0,2,"正弦",35) end
if t==(50) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(57) then R.change(o,"wscale",1.13,0,0,"正比",6) end
if t==(50) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(50) then R.change(o,"hscale",0.6,0,0,"正比",6) end
if t==(50) then R.change(o,"wscale",1.8,0,0,"正比",6) end
if t==(55) then R.change(o,"alpha",100,0,0,"正比",5) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=232,["begin"]=31,["life"]=240,["fx"]=512,["fy"]=242,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=600,["fdirection"]=240,["fdirections"]={0.0,0.0},["range"]=145,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=152,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.22,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/80)*80) then R.change(o,"fdirection",12,0,1,"正比",1) end
if t==(2+math.floor(t/80)*80) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(15) then R.change(o,"wscale",0.2,0,1,"正弦",35) end
if t==(1) then R.change(o,"wscale",2,0,0,"正比",13) end
if t==(55) then R.change(o,"sonaspeed",0.02,0,0,"正比",2) end
if t==(1) then R.change(o,"hscale",2,0,0,"正比",13) end
if t==(15) then R.change(o,"hscale",0.2,0,2,"正弦",35) end
if t==(50) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(50) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(55) then R.change(o,"sonspeed",1,0,0,"正比",5) end
if t==(51) then R.change(o,"hscale",1,0,0,"正比",12) end
if t==(51) then R.change(o,"wscale",2.5,0,0,"正比",12) end
if t==(63) then R.change(o,"hscale",2,0,0,"正比",12) end
if t==(63) then R.change(o,"wscale",2,0,0,"正比",12) end
if t==(75) then R.change(o,"hscale",1,0,0,"正比",50) end
if t==(75) then R.change(o,"wscale",1,0,0,"正比",50) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=232,["begin"]=301,["life"]=240,["fx"]=448,["fy"]=242,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=600,["fdirection"]=300,["fdirections"]={0.0,0.0},["range"]=145,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=152,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.22,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/80)*80) then R.change(o,"fdirection",12,0,2,"正比",1) end
if t==(2+math.floor(t/80)*80) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(15) then R.change(o,"wscale",0.2,0,1,"正弦",35) end
if t==(1) then R.change(o,"wscale",2,0,0,"正比",13) end
if t==(55) then R.change(o,"sonaspeed",0.02,0,0,"正比",2) end
if t==(1) then R.change(o,"hscale",2,0,0,"正比",13) end
if t==(15) then R.change(o,"hscale",0.2,0,2,"正弦",35) end
if t==(50) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(50) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(55) then R.change(o,"sonspeed",1,0,0,"正比",5) end
if t==(51) then R.change(o,"hscale",1,0,0,"正比",12) end
if t==(51) then R.change(o,"wscale",2.5,0,0,"正比",12) end
if t==(63) then R.change(o,"hscale",2,0,0,"正比",12) end
if t==(63) then R.change(o,"wscale",2,0,0,"正比",12) end
if t==(75) then R.change(o,"hscale",1,0,0,"正比",50) end
if t==(75) then R.change(o,"wscale",1,0,0,"正比",50) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=608,["y"]=456,["begin"]=73,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=155,["wscale"]=1.15,["hscale"]=1.15,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.18,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(39+math.floor(t/100)*100) then R.change(o,"type",1,0,1,"正比",1) end
if t==(44+math.floor(t/100)*100) then R.change(o,"type",1,0,1,"正比",1) end
if t==(49+math.floor(t/100)*100) then R.change(o,"type",5,0,1,"正比",1) end
if t==(61+math.floor(t/100)*100) then R.change(o,"head",90,0,1,"正比",33) end
if t==(39+math.floor(t/100)*100) then R.change(o,"head",270,0,0,"正比",1) end
if t==(89+math.floor(t/100)*100) then R.change(o,"type",1,0,1,"正比",1) end
if t==(94+math.floor(t/100)*100) then R.change(o,"type",1,0,1,"正比",1) end
if t==(99+math.floor(t/100)*100) then R.change(o,"type",9,0,2,"正比",1) end
if t==(1+math.floor(t/100)*100) then R.change(o,"head",90,0,2,"正比",33) end
if t==(89+math.floor(t/100)*100) then R.change(o,"head",270,0,0,"正比",1) end
if t==(1+math.floor(t/100)*100) then R.change(o,"sonspeed",3,0,0,"正比",1) end
if t==(1+math.floor(t/100)*100) then R.change(o,"sonspeedd",210,0,0,"正比",1) end
if t==(51+math.floor(t/100)*100) then R.change(o,"sonspeedd",330,0,0,"正比",1) end
if t==(51+math.floor(t/100)*100) then R.change(o,"sonspeed",3,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=704,["y"]=456,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=21,["type"]=147,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=215,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",270,90,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",3,1,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.05,0,0,"正比",21) end
if t==(1) then R.change(o,"hscale",0.05,0,0,"正比",21) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=232,["begin"]=31,["life"]=240,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=6,["fdirection"]=240,["fdirections"]={0.0,0.0},["range"]=145,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=74,["type"]=152,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.2,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/80)*80) then R.change(o,"fdirection",12,0,1,"正比",1) end
if t==(1+math.floor(t/80)*80) then R.change(o,"t",6,0,0,"正比",1) end
if t==(60+math.floor(t/80)*80) then R.change(o,"t",9999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(64) then R.change(o,"type",1,0,1,"正比",1) end
if t==(69) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15) then R.change(o,"wscale",0.1,0,1,"正弦",35) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",13) end
if t==(61) then R.change(o,"sonspeed",4.5,0,0,"正比",24) end
if t==(55) then R.change(o,"alpha",100,0,0,"正比",5) end
if t==(60) then R.change(o,"sonspeedd",230,0,0,"正比",1) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",13) end
if t==(57) then R.change(o,"hscale",1.13,0,0,"正比",6) end
if t==(15) then R.change(o,"hscale",0.1,0,2,"正弦",35) end
if t==(50) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(57) then R.change(o,"wscale",1.13,0,0,"正比",6) end
if t==(50) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(50) then R.change(o,"hscale",0.6,0,0,"正比",6) end
if t==(50) then R.change(o,"wscale",1.8,0,0,"正比",6) end
if t==(60) then R.change(o,"sonspeed",6,0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=544,["y"]=328,["begin"]=53,["life"]=50,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=29,["type"]=173,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeed",0.1,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",1,0.5,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270,130,0,"正比",1) end
if t==(15) then R.change(o,"type",1,0,1,"正比",1) end
if t==(21) then R.change(o,"alpha",1,0,0,"正比",8) end
if t==(1) then R.change(o,"head",0,360,0,"正比",1) end
if t==(1) then R.change(o,"hscale",1.3,0.5,0,"正比",40) end
if t==(1) then R.change(o,"wscale",1.3,0.5,0,"正比",40) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=672,["y"]=456,["begin"]=1,["life"]=200,["fx"]=-99998,["fy"]=-99998,["r"]=40,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=50,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=13,["type"]=166,["wscale"]=0.1,["hscale"]=0.03,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.3,0,0,"正比",13) end
if t==(7) then R.change(o,"alpha",31,0,0,"正比",6) end
if t==(1) then R.change(o,"hscale",0.4,0,0,"正比",13) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=false,["x"]=544,["y"]=360,["begin"]=1,["life"]=2,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=28,["type"]=159,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",28) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",28) end
if t==(2) then R.change(o,"sonspeed",0.1,0,0,"正比",36) end
if t==(1) then R.change(o,"sonspeed",3,2,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270,130,0,"正比",1) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=576,["y"]=552,["begin"]=1,["life"]=540,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=101,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=45,["colorG"]=21,["colorB"]=42,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=232,["begin"]=31,["life"]=240,["fx"]=512,["fy"]=232,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=600,["fdirection"]=240,["fdirections"]={0.0,0.0},["range"]=145,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=152,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=10,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.22,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/80)*80) then R.change(o,"fdirection",12,0,1,"正比",1) end
if t==(2+math.floor(t/80)*80) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(15) then R.change(o,"wscale",0.2,0,1,"正弦",35) end
if t==(1) then R.change(o,"wscale",2,0,0,"正比",13) end
if t==(55) then R.change(o,"sonaspeed",0.02,0,0,"正比",2) end
if t==(1) then R.change(o,"hscale",2,0,0,"正比",13) end
if t==(15) then R.change(o,"hscale",0.2,0,2,"正弦",35) end
if t==(50) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(50) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(55) then R.change(o,"sonspeed",1,0,0,"正比",5) end
if t==(51) then R.change(o,"hscale",1,0,0,"正比",12) end
if t==(51) then R.change(o,"wscale",2.5,0,0,"正比",12) end
if t==(63) then R.change(o,"hscale",2,0,0,"正比",12) end
if t==(63) then R.change(o,"wscale",2,0,0,"正比",12) end
if t==(75) then R.change(o,"hscale",1,0,0,"正比",50) end
if t==(75) then R.change(o,"wscale",1,0,0,"正比",50) end
end},
{["id"]=8,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=232,["begin"]=301,["life"]=240,["fx"]=448,["fy"]=232,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=600,["fdirection"]=300,["fdirections"]={0.0,0.0},["range"]=145,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=152,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=10,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.22,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/80)*80) then R.change(o,"fdirection",12,0,2,"正比",1) end
if t==(2+math.floor(t/80)*80) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(15) then R.change(o,"wscale",0.2,0,1,"正弦",35) end
if t==(1) then R.change(o,"wscale",2,0,0,"正比",13) end
if t==(55) then R.change(o,"sonaspeed",0.02,0,0,"正比",2) end
if t==(1) then R.change(o,"hscale",2,0,0,"正比",13) end
if t==(15) then R.change(o,"hscale",0.2,0,2,"正弦",35) end
if t==(50) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(50) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(55) then R.change(o,"sonspeed",1,0,0,"正比",5) end
if t==(51) then R.change(o,"hscale",1,0,0,"正比",12) end
if t==(51) then R.change(o,"wscale",2.5,0,0,"正比",12) end
if t==(63) then R.change(o,"hscale",2,0,0,"正比",12) end
if t==(63) then R.change(o,"wscale",2,0,0,"正比",12) end
if t==(75) then R.change(o,"hscale",1,0,0,"正比",50) end
if t==(75) then R.change(o,"wscale",1,0,0,"正比",50) end
end},
{["id"]=9,["parentid"]=2,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=false,["x"]=416,["y"]=328,["begin"]=53,["life"]=50,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=29,["type"]=173,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeed",0.1,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",1,0.5,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270,130,0,"正比",1) end
if t==(15) then R.change(o,"type",1,0,1,"正比",1) end
if t==(21) then R.change(o,"alpha",1,0,0,"正比",8) end
if t==(1) then R.change(o,"head",0,360,0,"正比",1) end
if t==(1) then R.change(o,"hscale",1.3,0.5,0,"正比",40) end
if t==(1) then R.change(o,"wscale",1.3,0.5,0,"正比",40) end
end},
{["id"]=10,["parentid"]=2,["Binding"]=false,["bindid"]=9,["Bindwithspeedd"]=false,["x"]=416,["y"]=360,["begin"]=1,["life"]=2,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=28,["type"]=159,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",28) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",28) end
if t==(2) then R.change(o,"sonspeed",0.1,0,0,"正比",36) end
if t==(1) then R.change(o,"sonspeed",3,2,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270,130,0,"正比",1) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=576,["y"]=456,["begin"]=73,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=162,["wscale"]=1.15,["hscale"]=1.15,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.18,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(39+math.floor(t/100)*100) then R.change(o,"type",1,0,1,"正比",1) end
if t==(44+math.floor(t/100)*100) then R.change(o,"type",1,0,1,"正比",1) end
if t==(49+math.floor(t/100)*100) then R.change(o,"type",9,0,2,"正比",1) end
if t==(61+math.floor(t/100)*100) then R.change(o,"head",90,0,2,"正比",33) end
if t==(39+math.floor(t/100)*100) then R.change(o,"head",270,0,0,"正比",1) end
if t==(89+math.floor(t/100)*100) then R.change(o,"type",1,0,1,"正比",1) end
if t==(94+math.floor(t/100)*100) then R.change(o,"type",1,0,1,"正比",1) end
if t==(99+math.floor(t/100)*100) then R.change(o,"type",5,0,1,"正比",1) end
if t==(1+math.floor(t/100)*100) then R.change(o,"head",90,0,1,"正比",33) end
if t==(89+math.floor(t/100)*100) then R.change(o,"head",270,0,0,"正比",1) end
if t==(1+math.floor(t/100)*100) then R.change(o,"sonspeed",3,0,0,"正比",1) end
if t==(1+math.floor(t/100)*100) then R.change(o,"sonspeedd",330,0,0,"正比",1) end
if t==(51+math.floor(t/100)*100) then R.change(o,"sonspeedd",210,0,0,"正比",1) end
if t==(51+math.floor(t/100)*100) then R.change(o,"sonspeed",3,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=false,["x"]=704,["y"]=424,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=21,["type"]=147,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=215,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",270,90,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",3,1,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.05,0,0,"正比",21) end
end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=232,["begin"]=301,["life"]=240,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=6,["fdirection"]=300,["fdirections"]={0.0,0.0},["range"]=145,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=74,["type"]=159,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.2,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/80)*80) then R.change(o,"fdirection",12,0,2,"正比",1) end
if t==(1+math.floor(t/80)*80) then R.change(o,"t",6,0,0,"正比",1) end
if t==(60+math.floor(t/80)*80) then R.change(o,"t",9999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(64) then R.change(o,"type",1,0,1,"正比",1) end
if t==(69) then R.change(o,"type",1,0,1,"正比",1) end
if t==(15) then R.change(o,"wscale",0.1,0,1,"正弦",35) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",13) end
if t==(61) then R.change(o,"sonspeed",4.5,0,0,"正比",24) end
if t==(60) then R.change(o,"sonspeed",6,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",310,0,0,"正比",1) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",13) end
if t==(57) then R.change(o,"hscale",1.13,0,0,"正比",6) end
if t==(15) then R.change(o,"hscale",0.1,0,2,"正弦",35) end
if t==(50) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(57) then R.change(o,"wscale",1.13,0,0,"正比",6) end
if t==(50) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(50) then R.change(o,"hscale",0.6,0,0,"正比",6) end
if t==(50) then R.change(o,"wscale",1.8,0,0,"正比",6) end
if t==(55) then R.change(o,"alpha",100,0,0,"正比",5) end
end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=672,["y"]=424,["begin"]=1,["life"]=200,["fx"]=-99998,["fy"]=-99998,["r"]=40,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=50,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=13,["type"]=166,["wscale"]=0.1,["hscale"]=0.03,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.3,0,0,"正比",13) end
if t==(7) then R.change(o,"alpha",31,0,0,"正比",6) end
if t==(1) then R.change(o,"hscale",0.4,0,0,"正比",13) end
end},
{["id"]=4,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=576,["y"]=584,["begin"]=1,["life"]=540,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=101,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=45,["colorG"]=21,["colorB"]=42,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end}
}}
