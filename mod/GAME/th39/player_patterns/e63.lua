return {["id"]="63",["total"]=120,["order"]=1,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,200,200,100,100,0,0,4,4,0,0,0,0,0,"zybzBLACK2"},{200,0,200,200,100,100,0,0,4,4,0,0,0,0,0,"zybzBLACK2"},{400,0,200,200,100,100,0,0,4,4,0,0,0,0,0,"zybzBLACK2"},{600,0,200,200,100,100,0,0,4,4,0,0,0,0,0,"zybzBLACK2"},{800,0,200,200,100,100,0,0,4,4,0,0,0,0,0,"zybzBLACK2"},{0,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"3-4mb"},{50,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"3-4mb"},{100,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"3-4mb"},{0,50,50,50,25,25,0,0,1,0,0,0,0,0,0,"3-4mb"},{50,50,50,50,25,25,0,0,1,0,0,0,0,0,0,"3-4mb"},{100,50,50,50,25,25,0,0,1,0,0,0,0,0,0,"3-4mb"},{0,0,100,50,25,25,0,0,1,0,0,0,0,0,0,"3-4mb"},{0,0,75,26,38,14,0,0,1,0,0,0,0,0,0,"bzxg-ZHUBAN"},{0,25,100,50,50,25,0,0,1,0,0,0,0,0,0,"bzxg-ZHUBAN"},{0,0,75,26,40,10,0,0,1,0,0,0,0,0,0,"bzxg-ZHUBAN"}},centerEvents=function(o,t,R)
if t==(1) then R.sound("stage3woodbreak") end
end,globalEvents=function(c,t,R)
if t==1 then R.quake(c,40,5) end
end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=424,["begin"]=1,["life"]=13,["fx"]=-99998,["fy"]=360,["r"]=40,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=70,["type"]=160,["wscale"]=0.5,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.04,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0.02,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",0,3,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270,70,0,"正比",1) end
if t==(1) then R.change(o,"head",0,600,1,"正比",60) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",6) end
if t==(51) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(1+math.floor(t/50)*50) then R.change(o,"wscale",0.1,0,0,"正弦",49) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=488,["begin"]=2,["life"]=9,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=164,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.06,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=10,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0.02,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(6) then R.change(o,"type",1,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2.5,1.5,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270,13,0,"正比",1) end
if t==(1) then R.change(o,"head",0,100,1,"正比",60) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",6) end
if t==(41) then R.change(o,"alpha",0,0,0,"正比",20) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=5,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=95,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=122,["colorB"]=1,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",5,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",5,0,0,"正比",15) end
if t==(1) then R.change(o,"colorG",1,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",15) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=78,["type"]=152,["wscale"]=1.8,["hscale"]=1.8,["colorR"]=215,["colorG"]=218,["colorB"]=215,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(20) then R.change(o,"type",1,0,1,"正比",1) end
if t==(40) then R.change(o,"type",1,0,1,"正比",1) end
if t==(60) then R.change(o,"type",1,0,1,"正比",1) end
if t==(11) then R.change(o,"Blend",0,0,0,"正比",1) end
if t==(1) then R.change(o,"head",0,360,0,"正比",1) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=520,["begin"]=2,["life"]=6,["fx"]=-99998,["fy"]=360,["r"]=50,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=164,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.06,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=10,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=10,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0.02,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(5) then R.change(o,"type",1,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2.5,1,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270,13,0,"正比",1) end
if t==(1) then R.change(o,"head",0,50,1,"正比",88) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",6) end
if t==(61) then R.change(o,"alpha",0,0,0,"正比",20) end
end}
}}
