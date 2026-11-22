-- 离线展开：e37.xna；事件均已编译为Lua条件和调用。
return {id="e37",total=200,centerAvailable=true,center={315,240,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,160,200,80,100,0,0},{160,0,160,200,80,100,0,0},{320,0,160,200,80,100,0,0},{480,0,160,200,80,100,0,0},{640,0,160,200,80,100,0,0},{800,0,160,200,80,100,0,0},{0,200,160,200,80,100,0,0},{160,200,160,200,80,100,0,0},{800,400,160,200,80,100,0,0},{640,400,160,200,80,100,0,0},{480,400,160,200,80,100,0,0},{320,400,160,200,80,100,0,0},{160,400,160,200,80,100,0,0},{0,400,160,200,80,100,0,0},{800,600,160,200,80,100,0,0},{640,600,160,200,80,100,0,0},{0,700,500,300,250,150,0,0},{550,804,44,189,22,340,0,0},{629,965,15,20,8,10,0,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=1,["life"]=200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=245,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/200)*200) then R.change(o,"r",5.0,0,1,"正弦",199) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=128,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=229,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(24+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(29+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(39+math.floor(t/40)*40) then R.change(o,"type",7.0,0,2,"正比",1) end
if t==(34+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=128,["begin"]=5,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=237,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(24+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(29+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(39+math.floor(t/40)*40) then R.change(o,"type",7.0,0,2,"正比",1) end
if t==(34+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=128,["y"]=160,["begin"]=10,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=237,["wscale"]=0.25,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=220,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(24+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(29+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(39+math.floor(t/40)*40) then R.change(o,"type",7.0,0,2,"正比",1) end
if t==(34+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=160,["begin"]=10,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=229,["wscale"]=0.25,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=320,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(24+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(29+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(39+math.floor(t/40)*40) then R.change(o,"type",7.0,0,2,"正比",1) end
if t==(34+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=128,["y"]=256,["begin"]=20,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=237,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=220,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(24+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(29+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(39+math.floor(t/40)*40) then R.change(o,"type",7.0,0,2,"正比",1) end
if t==(34+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=256,["begin"]=15,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=229,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=330,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(24+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(29+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(39+math.floor(t/40)*40) then R.change(o,"type",7.0,0,2,"正比",1) end
if t==(34+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=192,["begin"]=1,["life"]=200,["fx"]=188,["fy"]=230,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=20,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=160,["type"]=247,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=225,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.45,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=60,["fy"]=60,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",45.0,0,2,"正比",30) end
if t==(1) then R.change(o,"alpha",90.0,0,0,"正比",20) end
if t==(90) then R.change(o,"alpha",10.0,0,0,"正比",90) end
if t==(61) then R.change(o,"sonaspeedd",0.0,300.0,1,"正比",120) end
if t==(60) then R.change(o,"head",0.0,350.0,1,"正比",120) end
if t==(60) then R.change(o,"sonaspeed",0.01,0.005,0,"正比",1) end
if t==(59) then R.change(o,"hscale",0.6,0,0,"正比",1) end
if t==(165) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(75) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(90) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(60) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(60) then R.change(o,"sonspeed",0.3,0.1,0,"正比",1) end
if t==(105) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(120) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(135) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(150) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(59) then R.change(o,"wscale",0.3,0,0,"正比",1) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=192,["begin"]=9,["life"]=192,["fx"]=444,["fy"]=230,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=20,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=160,["type"]=247,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=225,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.45,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=60,["fy"]=60,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(90) then R.change(o,"alpha",10.0,0,0,"正比",90) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",45.0,0,2,"正比",30) end
if t==(1) then R.change(o,"alpha",90.0,0,0,"正比",20) end
if t==(61) then R.change(o,"sonaspeedd",0.0,300.0,1,"正比",120) end
if t==(60) then R.change(o,"head",0.0,350.0,1,"正比",120) end
if t==(60) then R.change(o,"sonaspeed",0.01,0.005,0,"正比",1) end
if t==(59) then R.change(o,"hscale",0.6,0,0,"正比",1) end
if t==(165) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(75) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(90) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(60) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(60) then R.change(o,"sonspeed",0.3,0.1,0,"正比",1) end
if t==(105) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(120) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(135) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(150) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(59) then R.change(o,"wscale",0.3,0,0,"正比",1) end
end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=6,["life"]=195,["fx"]=316,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=25,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=247,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=225,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.45,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=60,["fy"]=20,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(120) then R.change(o,"alpha",10.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeedd",45.0,0,2,"正比",30) end
if t==(1) then R.change(o,"alpha",90.0,0,0,"正比",20) end
if t==(61) then R.change(o,"sonaspeedd",0.0,300.0,1,"正比",120) end
if t==(60) then R.change(o,"head",0.0,350.0,1,"正比",120) end
if t==(60) then R.change(o,"sonaspeed",0.01,0.005,0,"正比",1) end
if t==(59) then R.change(o,"hscale",0.6,0,0,"正比",1) end
if t==(165) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(75) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(90) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(60) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(60) then R.change(o,"sonspeed",0.3,0.1,0,"正比",1) end
if t==(105) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(120) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(135) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(150) then R.change(o,"wscale",0.01,0,0,"正弦",14) end
if t==(59) then R.change(o,"wscale",0.3,0,0,"正比",1) end
end}
}}
