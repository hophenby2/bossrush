-- 离线展开：b727.xna；事件均已编译为Lua条件和调用。
return {id="727",total=5000,centerAvailable=true,center={315,175,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,200,200,100,100,0,1},{200,0,200,200,100,100,0,1},{400,0,200,200,100,100,0,1},{0,200,30,30,15,15,5,0},{30,200,30,30,15,15,5,0},{600,0,200,200,100,100,0,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=60,["life"]=4821,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=23,["t"]=90,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=225,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",180) end
if t==(1) then R.change(o,"colorB",255.0,0,0,"正比",180) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",180) end
if t==(1) then R.change(o,"colorG",255.0,0,0,"正比",180) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=321,["y"]=0,["begin"]=31,["life"]=4970,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=6,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=6,["wscale"]=0.2,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=10,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360.0,0,1,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=288,["y"]=256,["begin"]=61,["life"]=4940,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=6,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=579,["y"]=130,["begin"]=1,["life"]=5000,["fx"]=-99998,["fy"]=-99998,["r"]=45,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=560,["type"]=229,["wscale"]=0.55,["hscale"]=0.55,["colorR"]=165,["colorG"]=165,["colorB"]=165,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(35+math.floor(t/90)*90) then R.change(o,"alpha",100.0,0,0,"正比",10) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(15+math.floor(t/90)*90) then R.change(o,"alpha",100.0,0,0,"正比",30) end
if t==(1100) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=352,["begin"]=1,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=1,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=125,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",800) end
if t==(1) then R.change(o,"type",233.0,0,0,"正比",1) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5000,["type"]=225,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=125,["colorB"]=15,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",6.0,0,0,"正比",360) end
if t==(1) then R.change(o,"hscale",6.0,0,0,"正比",360) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=57,["y"]=241,["begin"]=1,["life"]=5000,["fx"]=-99998,["fy"]=-99998,["r"]=45,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=560,["type"]=229,["wscale"]=0.55,["hscale"]=0.55,["colorR"]=165,["colorG"]=165,["colorB"]=165,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(35+math.floor(t/90)*90) then R.change(o,"alpha",100.0,0,0,"正比",10) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(15+math.floor(t/90)*90) then R.change(o,"alpha",100.0,0,0,"正比",30) end
if t==(1100) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=475,["y"]=448,["begin"]=1,["life"]=5000,["fx"]=-99998,["fy"]=570,["r"]=45,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=560,["type"]=229,["wscale"]=0.55,["hscale"]=0.55,["colorR"]=185,["colorG"]=185,["colorB"]=185,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(35+math.floor(t/90)*90) then R.change(o,"alpha",100.0,0,0,"正比",10) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(15+math.floor(t/90)*90) then R.change(o,"alpha",100.0,0,0,"正比",30) end
if t==(1100) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=165,["y"]=448,["begin"]=1,["life"]=5000,["fx"]=-99998,["fy"]=570,["r"]=45,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=560,["type"]=229,["wscale"]=0.55,["hscale"]=0.55,["colorR"]=185,["colorG"]=185,["colorB"]=185,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(35+math.floor(t/90)*90) then R.change(o,"alpha",100.0,0,0,"正比",10) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(15+math.floor(t/90)*90) then R.change(o,"alpha",100.0,0,0,"正比",30) end
if t==(1100) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=1,["life"]=5000,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=6,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=5,["wscale"]=0.2,["longs"]=100,["alpha"]=80,["Ray"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="laser",["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360.0,0,1,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(51) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(51) then R.change(o,"wscale",2.0,1.0,0,"正比",11) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=1,["life"]=5000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=51,["t"]=48,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=30,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end}
}}
