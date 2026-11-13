return {["id"]="2441",["total"]=3300,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,50,200,25,10,0,0,1,0,0,0,0,0,0,"2-Snakeseye"},{50,0,50,430,24,420,0,0,1,0,0,0,0,0,0,"2-Snakeseye"},{100,0,50,200,25,100,0,0,1,0,0,0,0,0,0,"2-Snakeseye"}},centerEvents=function(o,t,R)
if t==(1) then R.sound("stage2whoosh") end
if t==(15) then R.sound("stage2whoosh") end
if t==(30) then R.sound("stage2whoosh") end
if t==(45) then R.sound("stage2whoosh") end
if t==(62) then R.sound("stage2claves") end
end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=780,["y"]=334,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=240,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=154,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=12,["colorG"]=12,["colorB"]=12,["alpha"]=100,["head"]=-1000,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=10,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.3,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(90) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(89) then R.change(o,"sonaspeed",0,0,0,"正比",1) end
if t==(1) then R.change(o,"head",90,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0.9,0,0,"正比",90) end
if t==(1) then R.change(o,"hscale",0.9,0,0,"正比",90) end
if t==(60) then R.change(o,"sonspeed",5,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(61) then R.change(o,"sonspeed",-5,0,0,"正比",60) end
if t==(62) then R.change(o,"head",360,0,2,"无缝正弦",230) end
if t==(72) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(1) then R.change(o,"colorR",255,0,0,"正比",12) end
if t==(1) then R.change(o,"colorG",255,0,0,"正比",12) end
if t==(1) then R.change(o,"colorB",255,0,0,"正比",12) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=780,["y"]=334,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=240,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=154,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=12,["colorG"]=12,["colorB"]=12,["alpha"]=30,["head"]=-1000,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=10,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.3,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(90) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(89) then R.change(o,"sonaspeed",0,0,0,"正比",1) end
if t==(1) then R.change(o,"head",90,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0.9,0,0,"正比",90) end
if t==(1) then R.change(o,"hscale",0.9,0,0,"正比",90) end
if t==(60) then R.change(o,"sonspeed",5,0,0,"正比",1) end
if t==(60) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(61) then R.change(o,"sonspeed",-5,0,0,"正比",60) end
if t==(62) then R.change(o,"head",360,0,2,"无缝正弦",230) end
if t==(72) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(1) then R.change(o,"colorR",255,0,0,"正比",12) end
if t==(1) then R.change(o,"colorG",255,0,0,"正比",12) end
if t==(1) then R.change(o,"colorB",255,0,0,"正比",12) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=136,["begin"]=61,["life"]=1,["fx"]=-99998,["fy"]=410,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=18,["type"]=91,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=77,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",18) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",18) end
if t==(1) then R.change(o,"hscale",1.3,0,0,"正比",18) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=104,["begin"]=60,["life"]=1,["fx"]=-99998,["fy"]=410,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=14,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=200,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=18,["type"]=17,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",3,2,0,"正比",1) end
if t==(1) then R.change(o,"life",18,5,0,"正比",1) end
if t==(9) then R.change(o,"alpha",1,0,0,"正比",9) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",18) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=119,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=18,["type"]=96,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=77,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",4,0,0,"正比",18) end
if t==(6) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",4,0,0,"正比",18) end
end}
}}
