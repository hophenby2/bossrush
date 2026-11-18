-- 离线展开：e10.xna；事件均已编译为Lua条件和调用。
return {id="e10",total=60,centerAvailable=true,center={315,240,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{13,18,50,47,25,23,0,0},{72,0,80,80,40,40,0,0},{172,0,82,80,41,40,0,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=1,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=40,["type"]=229,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=0,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=180,["sonspeed"]=3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",0.0,180.0,0,"固定",1) end
if t==(1) then R.fire(o) end
if t==(1) then R.change(o,"fdirection",0.0,180.0,0,"固定",1) end
if t==(1) then R.fire(o) end
if t==(1) then R.change(o,"fdirection",0.0,180.0,0,"固定",1) end
if t==(1) then R.fire(o) end
if t==(1) then R.change(o,"fdirection",0.0,180.0,0,"固定",1) end
if t==(1) then R.fire(o) end
if t==(1) then R.change(o,"fdirection",0.0,180.0,0,"固定",1) end
if t==(1) then R.fire(o) end
if t==(1) then R.change(o,"fdirection",0.0,180.0,0,"固定",1) end
if t==(1) then R.fire(o) end
if t==(1) then R.change(o,"fdirection",0.0,180.0,0,"固定",1) end
if t==(1) then R.fire(o) end
if t==(1) then R.change(o,"fdirection",0.0,180.0,0,"固定",1) end
if t==(1) then R.fire(o) end
if t==(1) then R.change(o,"fdirection",0.0,180.0,0,"固定",1) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",0.0,0,0,"正比",40) end
if t==(1) then R.change(o,"sonspeed",1.0,0,0,"正比",20) end
if t==(1) then R.change(o,"head",60.0,20.0,1,"正比",40) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=230,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.5,0,1,"正比",20) end
if t==(1) then R.change(o,"hscale",1.5,0,1,"正比",20) end
if t==(1) then R.change(o,"alpha",0.0,0,0,"正比",20) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=230,["wscale"]=1.8,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=180,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.5,0,1,"正比",20) end
if t==(1) then R.change(o,"alpha",0.0,0,0,"正比",20) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",20) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=231,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=180,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fx",0.0,10.0,1,"固定",1) end
if t==(1) then R.change(o,"fy",0.0,10.0,1,"固定",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,1,"正比",10) end
if t==(1) then R.change(o,"hscale",1.0,0,1,"正比",10) end
if t==(10) then R.change(o,"wscale",0.3,0,1,"正比",35) end
if t==(10) then R.change(o,"hscale",0.3,0,1,"正比",35) end
if t==(10) then R.change(o,"alpha",0.0,0,0,"正比",30) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=231,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=180,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fx",0.0,10.0,1,"固定",1) end
if t==(1) then R.change(o,"fy",0.0,10.0,1,"固定",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,1,"正比",10) end
if t==(1) then R.change(o,"hscale",1.0,0,1,"正比",10) end
if t==(10) then R.change(o,"wscale",0.3,0,1,"正比",35) end
if t==(10) then R.change(o,"hscale",0.3,0,1,"正比",35) end
if t==(10) then R.change(o,"alpha",0.0,0,0,"正比",30) end
end}
}}
