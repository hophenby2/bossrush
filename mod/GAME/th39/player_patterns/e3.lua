return {["id"]="3",["total"]=60,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,200,200,100,100,0,0,4,3,0,0,0,0,0,"zybzBLUE1"},{0,0,200,200,100,100,0,0,4,3,0,0,0,0,0,"zybzBLUE2"},{200,0,200,200,100,100,0,0,4,3,0,0,0,0,0,"zybzBLUE1"},{200,0,200,200,100,100,0,0,4,3,0,0,0,0,0,"zybzBLUE2"},{400,0,200,200,100,100,0,0,4,3,0,0,0,0,0,"zybzBLUE1"},{400,0,200,200,100,100,0,0,4,3,0,0,0,0,0,"zybzBLUE2"},{600,0,200,200,100,100,0,0,4,3,0,0,0,0,0,"zybzBLUE1"},{600,0,200,200,100,100,0,0,4,3,0,0,0,0,0,"zybzBLUE2"},{800,0,200,200,100,100,0,0,4,3,0,0,0,0,0,"zybzBLUE1"},{800,0,200,200,100,100,0,0,4,3,0,0,0,0,0,"zybzBLUE2"},{0,0,200,200,100,100,0,0,1,0,0,0,0,0,0,"pzSHgreen"},{200,0,200,200,100,100,0,0,1,0,0,0,0,0,0,"pzSHgreen"},{400,0,200,200,100,100,0,0,1,0,0,0,0,0,0,"pzSHgreen"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=2,["life"]=36,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=11,["type"]=152,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(12) then R.change(o,"type",2,0,1,"正比",1) end
if t==(24) then R.change(o,"type",2,0,1,"正比",1) end
if t==(36) then R.change(o,"type",2,0,1,"正比",1) end
if t==(48) then R.change(o,"type",2,0,1,"正比",1) end
if t==(12) then R.change(o,"Blend",0,0,0,"正比",1) end
if t==(2) then R.fire(o) end
if t==(1) then R.change(o,"type",1,1,1,"正比",1) end
if t==(1) then R.change(o,"head",0,360,0,"正比",1) end
if t==(6) then R.change(o,"life",12,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=1,["life"]=3,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=162,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0.4,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1) then R.fire(o) end
if t==(2) then R.change(o,"type",1,0,1,"正比",1) end
if t==(2) then R.fire(o) end
if t==(3) then R.fire(o) end
if t==(1) then R.change(o,"fdirection",360,0,1,"正比",3) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,60,1,"正比",50) end
if t==(20) then R.change(o,"alpha",1,0,0,"正比",10) end
if t==(1) then R.change(o,"wscale",0.9,0.2,0,"正弦",120) end
if t==(1) then R.change(o,"hscale",0.9,0.2,0,"正弦",120) end
if t==(1) then R.change(o,"sonspeed",0.1,0,0,"正比",30) end
if t==(20) then R.change(o,"colorB",1,0,0,"正比",10) end
if t==(1) then R.change(o,"head",0,30,1,"正比",50) end
end}
}}
