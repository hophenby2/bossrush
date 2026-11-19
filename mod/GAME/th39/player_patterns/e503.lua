return {["id"]="503",["total"]=4000,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,300,300,150,150,0,0,1,0,0,0,0,0,0,"zhen1"},{0,0,500,150,250,75,0,0,4,4,0,0,0,0,0,"lmsd"},{0,0,300,300,150,150,0,0,1,0,0,0,0,0,0,"lmyyy"},{303,0,30,60,15,10,0,0,1,0,0,0,0,0,0,"lmyyy"},{333,0,100,100,50,40,0,0,1,0,0,0,0,0,0,"lmyyy"},{0,0,300,300,150,150,0,0,1,0,0,0,0,0,0,"lmyyy2"},{0,0,100,300,50,300,0,0,1,0,0,0,0,0,0,"TyndallEffect"},{0,0,250,250,125,125,0,0,1,0,0,0,0,0,0,"paopao"},{0,0,100,100,50,50,0,0,1,0,0,0,0,0,0,"quan"},{300,0,100,100,50,50,0,0,13,3,0,0,0,0,0,"lantern-3"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=616,["begin"]=1,["life"]=4000,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=20,["t"]=10,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=45,["type"]=158,["wscale"]=0.1,["hscale"]=0.3,["colorR"]=255,["colorG"]=66,["colorB"]=66,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"hscale",0,0,0,"正比",45) end
if t==(15) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",0,13,1,"无缝正弦",250) end
if t==(1) then R.change(o,"wscale",0.4,0.2,0,"正比",120) end
if t==(1) then R.change(o,"hscale",0.3,0.2,0,"正比",1) end
if t==(1) then R.change(o,"alpha",60,30,0,"正比",9) end
end}
}}
