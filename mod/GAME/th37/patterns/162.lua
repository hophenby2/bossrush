-- 离线展开：b162.xna；事件均已编译为Lua条件和调用。
return {id="162",total=6300,centerAvailable=true,center={315,175,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{1,0,55,43,27,21,0,0},{56,0,55,43,24,21,0,0},{0,44,31,28,15,14,0,7},{31,44,31,28,15,14,0,7},{0,72,20,40,10,20,7,7}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=61,["life"]=6200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=119,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=310,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.4,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/121)*121) then R.change(o,"r",260.0,0,2,"正弦",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0.0,8.0,1,"正比",222) end
if t==(1) then R.change(o,"sonspeed",0.0,1.0,1,"正比",122) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=256,["y"]=64,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=227,["wscale"]=0.5,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",3.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeed",3.0,2.0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeedd",0.0,5.0,1,"正比",1) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",30) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=64,["begin"]=1,["life"]=50,["fx"]=316,["fy"]=140,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=4,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=1,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=20,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"range",540.0,0,0,"正比",50) end
if t==(1) then R.change(o,"sonlife",30.0,0,0,"正比",50) end
if t==(1) then R.change(o,"sonspeed",120.0,0,0,"正比",50) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.0,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=256,["y"]=96,["begin"]=1,["life"]=6300,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=20,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=231,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=460,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2.0,1.5,0,"正比",1) end
if t==(100) then R.change(o,"wscale",0.0,0,0,"正比",50) end
if t==(100) then R.change(o,"hscale",0.0,0,0,"正比",50) end
if t==(1) then R.change(o,"sonspeedd",0.0,1.0,1,"正比",1) end
if t==(1) then R.change(o,"sonaspeedd",90.0,180.0,0,"正比",1) end
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",100) end
if t==(1) then R.change(o,"sonspeed",0.1,0,0,"正比",100) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=288,["y"]=64,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=227,["wscale"]=0.8,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2.0,1.0,0,"正比",50) end
if t==(20) then R.change(o,"alpha",0.0,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",15.0,0,0,"正比",20) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=101,["life"]=6200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=232,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=310,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.4,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",2.0,0,2,"正弦",89) end
if t==(1+math.floor(t/90)*90) then R.change(o,"head",20.0,0,1,"正弦",89) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=111,["life"]=6190,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=231,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=230,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.4,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",2.0,0,2,"正弦",89) end
if t==(1+math.floor(t/90)*90) then R.change(o,"head",20.0,0,1,"正弦",89) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=61,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=114,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=310,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.4,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/121)*121) then R.change(o,"r",260.0,0,2,"正弦",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0.0,15.0,1,"正比",222) end
if t==(1) then R.change(o,"sonspeed",0.0,1.0,1,"正比",122) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=61,["life"]=6200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=24,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=310,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.4,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/121)*121) then R.change(o,"r",260.0,0,1,"正弦",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0.0,15.0,1,"正比",222) end
if t==(1) then R.change(o,"sonspeed",0.0,1.0,1,"正比",122) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=64,["begin"]=75,["life"]=1,["fx"]=316,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=50,["type"]=227,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",50.0,0,0,"正比",50) end
if t==(1) then R.change(o,"hscale",50.0,0,0,"正比",50) end
if t==(20) then R.change(o,"alpha",0.0,0,0,"正比",30) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=96,["begin"]=1,["life"]=2,["fx"]=316,["fy"]=144,["r"]=250,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=12,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=227,["wscale"]=3,["hscale"]=3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=10,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,1,"正弦",50) end
if t==(1) then R.change(o,"rdirection",360.0,0,1,"正弦",50) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.0,0,0,"正比",50) end
if t==(1) then R.change(o,"alpha",75.0,0,0,"正比",50) end
if t==(1) then R.change(o,"head",0.0,180.0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=128,["begin"]=75,["life"]=1,["fx"]=316,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=25,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=75,["type"]=231,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=35,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=10,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.05,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,1,"正弦",50) end
if t==(1) then R.change(o,"rdirection",360.0,0,1,"正弦",50) end
end,Sonevents=function(o,t,R)
if t>(0+math.floor(t/40)*40) then R.change(o,"head",5.0,0,1,"正比",1) end
if t==(1+math.floor(t/40)*40) then R.change(o,"wscale",0.0,0,0,"正比",20) end
if t==(21+math.floor(t/40)*40) then R.change(o,"wscale",3.0,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",5.0,0,0,"正比",150) end
if t==(1) then R.change(o,"sonspeed",7.0,3.5,0,"正比",1) end
if t==(1) then R.change(o,"head",0.0,180.0,0,"正比",1) end
if t==(50) then R.change(o,"alpha",0.0,0,0,"正比",25) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=128,["begin"]=75,["life"]=1,["fx"]=316,["fy"]=144,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=36,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=75,["type"]=231,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=35,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=10,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.05,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360.0,0,1,"正弦",50) end
if t==(1) then R.change(o,"rdirection",360.0,0,1,"正弦",50) end
end,Sonevents=function(o,t,R)
if t>(0+math.floor(t/40)*40) then R.change(o,"head",5.0,0,1,"正比",1) end
if t==(1+math.floor(t/40)*40) then R.change(o,"wscale",0.0,0,0,"正比",20) end
if t==(21+math.floor(t/40)*40) then R.change(o,"wscale",3.0,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",5.0,0,0,"正比",150) end
if t==(1) then R.change(o,"sonspeed",4.0,3.5,0,"正比",1) end
if t==(1) then R.change(o,"head",0.0,180.0,0,"正比",1) end
if t==(50) then R.change(o,"alpha",0.0,0,0,"正比",25) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=91,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=80,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=10,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=60,["life"]=10,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=15,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=7200,["type"]=231,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.3,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=359,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,5500.0,1,"正比",5200) end
if t==(1) then R.change(o,"sonspeed",7.0,2.0,0,"正比",200) end
if t==(1+math.floor(t/200)*200) then R.change(o,"sonspeedd",360.0,0,1,"正比",200) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=60,["life"]=20,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=25,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=7200,["type"]=232,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.3,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=359,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,5500.0,1,"正比",5200) end
if t==(1) then R.change(o,"alpha",12.0,5.0,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",5.0,2.0,0,"正比",200) end
if t==(1+math.floor(t/200)*200) then R.change(o,"sonspeedd",360.0,0,1,"正比",200) end
end}
}}
