-- 离线展开：b656.xna；事件均已编译为Lua条件和调用。
return {id="656",total=1360,centerAvailable=true,center={315,175,0,0,0,0},centerEvents=function(o,t,R)
if t==(180) then R.move(o,260,370,176,175) end
if t==(300) then R.move(o,260,370,176,175) end
end,globalEvents=function(c,t,R)
if t==360 then R.jump(c,1,0,121) end
end,types={{0,0,40,40,20,20,8,0},{40,0,40,40,20,20,8,0},{80,0,40,40,20,20,8,0},{120,0,40,40,20,20,8,0},{160,0,28,43,13,21,5,0},{0,41,56,62,28,36,15,0},{56,41,56,62,28,36,15,0},{112,40,28,28,14,14,5,2},{112,68,28,28,14,14,5,0},{140,43,35,21,17,11,5,0},{140,64,35,21,17,11,5,0},{0,102,388,388,194,194,50,0},{460,0,45,45,22,22,3,0},{505,0,45,45,22,22,3,0},{550,0,45,45,22,22,3,0},{595,0,45,45,22,22,3,0},{460,45,45,45,22,22,3,0},{505,45,45,45,22,22,3,0},{550,45,45,45,22,22,3,0},{595,45,45,45,22,22,3,0},{460,90,45,45,22,22,3,0},{505,90,45,45,22,22,3,0},{550,90,45,45,22,22,3,0},{595,90,45,45,22,22,3,0},{460,135,45,45,22,22,3,0},{505,135,45,45,22,22,3,0},{550,135,45,45,22,22,3,0},{595,135,45,45,22,22,3,0},{388,180,248,141,124,130,0,0},{388,321,248,141,124,130,0,0},{388,462,248,141,124,130,0,0},{188,0,45,59,23,30,4,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=170,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=224,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",30.0,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",0.0,0,0,"正比",240) end
if t==(1) then R.change(o,"hscale",30.0,0,0,"正比",30) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=138,["begin"]=121,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=16,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=174,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222.0,0,1,"正比",22) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=138,["begin"]=241,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=16,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=174,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222.0,0,1,"正比",22) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=138,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=30,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=174,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222.0,0,1,"正比",22) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=138,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=30,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=174,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222.0,0,1,"正比",22) end
if t==(60) then R.change(o,"sonspeed",1.0,0,1,"正比",30) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=138,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=30,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=174,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222.0,0,1,"正比",22) end
if t==(60) then R.change(o,"sonspeed",2.0,0,1,"正比",30) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=138,["begin"]=181,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=16,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=174,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222.0,0,1,"正比",22) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=264,["y"]=12,["begin"]=121,["life"]=33,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(32) then R.change(o,"r",0.0,0,0,"正比",1) end
if t==(1) then R.change(o,"r",450.0,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",12) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeedd",280.0,0,0,"正比",1) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(210+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(179+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",260.0,0,0,"正比",1) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(90+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(59+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=375,["y"]=12,["begin"]=241,["life"]=33,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(32) then R.change(o,"r",0.0,0,0,"正比",1) end
if t==(1) then R.change(o,"r",450.0,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",12) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeedd",280.0,0,0,"正比",1) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(210+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(179+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",260.0,0,0,"正比",1) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(90+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(59+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=375,["y"]=12,["begin"]=241,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",12) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeedd",280.0,0,0,"正比",1) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(210+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(179+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",260.0,0,0,"正比",1) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(90+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(59+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=264,["y"]=12,["begin"]=121,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",12) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeedd",280.0,0,0,"正比",1) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(210+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(179+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",260.0,0,0,"正比",1) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(90+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(59+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=138,["begin"]=121,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=22,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=237,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"head",360.0,0,1,"正比",30) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=138,["begin"]=241,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=22,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=237,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"head",360.0,0,1,"正比",30) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=264,["y"]=82,["begin"]=1,["life"]=33,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(32) then R.change(o,"r",0.0,0,0,"正比",1) end
if t==(1) then R.change(o,"r",450.0,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",12) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeedd",260.0,0,0,"正比",1) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(210+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(179+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",280.0,0,0,"正比",1) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(90+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(59+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=264,["y"]=82,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",12) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeedd",260.0,0,0,"正比",1) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(210+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(179+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",280.0,0,0,"正比",1) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(90+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(59+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
end},
{["id"]=8,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=375,["y"]=12,["begin"]=1,["life"]=33,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(32) then R.change(o,"r",0.0,0,0,"正比",1) end
if t==(1) then R.change(o,"r",450.0,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",12) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeedd",280.0,0,0,"正比",1) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(210+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(179+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",260.0,0,0,"正比",1) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(90+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(59+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
end},
{["id"]=9,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=375,["y"]=12,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",12) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeedd",280.0,0,0,"正比",1) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(210+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(179+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",260.0,0,0,"正比",1) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(90+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(59+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
end},
{["id"]=10,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=375,["y"]=154,["begin"]=1,["life"]=33,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(32) then R.change(o,"r",0.0,0,0,"正比",1) end
if t==(1) then R.change(o,"r",450.0,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",12) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeedd",280.0,0,0,"正比",1) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(210+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(179+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",260.0,0,0,"正比",1) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(90+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(59+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
end},
{["id"]=11,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=375,["y"]=154,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=234,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.55,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",12) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeedd",280.0,0,0,"正比",1) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(121+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(210+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(181+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(179+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeedd",260.0,0,0,"正比",1) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",2.0,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.135,0,0,"正比",1) end
if t==(90+math.floor(t/240)*240) then R.change(o,"head",3.0,0,1,"正弦",29) end
if t==(61+math.floor(t/240)*240) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
if t==(59+math.floor(t/240)*240) then R.change(o,"head",6.0,0,1,"正弦",29) end
end},
{["id"]=12,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=138,["begin"]=181,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=22,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6200,["type"]=237,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"head",360.0,0,1,"正比",30) end
end}
}}
