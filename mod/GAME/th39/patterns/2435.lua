return {["id"]="2435",["total"]=2200,["order"]=1,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={},centerEvents=function(o,t,R)
if t==(600) then R.sound("stage2kaze") end
if t==(760) then R.sound("stage2glass") end
if t==(800) then R.sound("stage2glass") end
if t==(860) then R.sound("stage2glass") end
if t==(870) then R.sound("stage2glass") end
if t==(880) then R.sound("stage2glass") end
if t==(890) then R.sound("stage2glass") end
if t==(900) then R.sound("stage2glass") end
if t==(905) then R.sound("stage2glass") end
if t==(910) then R.sound("stage2glass") end
end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=41,["life"]=178,["fx"]=480,["fy"]=-40,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=33,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2200,["type"]=1,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.6,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/9)*9) then R.change(o,"r",250,0,1,"正弦",8) end
if t==(1+math.floor(t/9)*9) then R.change(o,"wscale",1,0,0,"正比",1) end
if t==(5+math.floor(t/9)*9) then R.change(o,"wscale",-1,0,0,"正比",1) end
if t==(120) then R.change(o,"t",13,0,0,"正比",1) end
if t==(172) then R.change(o,"t",2,0,0,"正比",1) end
if t==(110) then R.change(o,"speed",4,0,0,"正比",1) end
if t==(170) then R.change(o,"speed",35,0,0,"正比",1) end
if t==(176) then R.change(o,"speed",-25,0,0,"正比",1) end
if t==(70) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(110) then R.change(o,"t",33,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(3) then R.change(o,"sonspeed",1,0,0,"正比",1) end
if t==(3) then R.change(o,"sonspeedd",90,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=31,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=73,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=660,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/3)*3) then R.change(o,"wscale",1.3,0.3,0,"正比",2) end
if t==(1+math.floor(t/3)*3) then R.change(o,"hscale",0.7,0.3,0,"正比",2) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=480,["y"]=424,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=660,["type"]=98,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"wscale",1,0.3,0,"正比",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"hscale",1,0.3,0,"正比",12) end
if t==(658) then R.change(o,"alpha",55,0,0,"正比",2) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=480,["y"]=456,["begin"]=658,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=4,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=130,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=150,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,130,1,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.5,0,0,"正比",60) end
if t==(61) then R.change(o,"sonspeedd",0,230,1,"正比",120) end
if t==(61) then R.change(o,"sonspeed",3,1,1,"正比",120) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=false,["x"]=480,["y"]=520,["begin"]=61,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=60,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=78,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60) then R.change(o,"sonspeed",1,0,1,"正比",120) end
end}
}}
