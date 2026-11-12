-- 离线展开：b837.xna；事件均已编译为Lua条件和调用。
return {id="837",total=420,centerAvailable=true,center={315,175,0,0,0,0},centerEvents=function(o,t,R)
if t==(50) then R.sound("ch000") end
if t==(180) then R.sound("enep03") end
if t==(240) then R.sound("boon02") end
if t==(360) then R.follow(o) end
end,globalEvents=function(c,t,R)
if t==240 then R.quake(c,60,5) end
if t==300 then R.quake(c,120,7) end
end,types={{0,0,60,54,30,27,8,0},{60,0,64,62,32,31,8,0},{124,0,56,53,28,27,7,0},{180,0,18,24,9,12,1,0},{180,27,17,25,9,13,1,0},{207,24,11,11,5,5,1,0},{0,62,194,194,97,97,70,0},{194,62,192,192,96,96,70,0},{344,256,86,132,43,120,10,0},{430,256,86,132,43,120,10,0},{0,256,344,344,172,172,1,0},{0,600,392,392,196,196,1,0},{344,399,135,168,67,84,1,0},{459,0,45,45,22,18,2,0},{505,0,45,45,22,18,2,0},{550,0,45,45,22,18,2,0},{595,0,45,45,22,18,2,0},{459,45,45,45,22,18,2,0},{505,45,45,45,22,18,2,0},{550,45,45,45,22,18,2,0},{595,45,45,45,22,18,2,0},{460,90,45,45,22,22,3,0},{505,90,45,45,22,22,3,0},{550,90,45,45,22,22,3,0},{595,90,45,45,22,22,3,0},{460,135,45,45,22,22,3,0},{505,135,45,45,22,22,3,0},{550,135,45,45,22,22,3,0},{595,135,45,45,22,22,3,0},{373,0,21,31,10,15,2,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=384,["begin"]=240,["life"]=12,["fx"]=314,["fy"]=600,["r"]=20,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=550,["type"]=237,["wscale"]=0.7,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2) then R.change(o,"r",330.0,0,1,"正比",11) end
if t==(1) then R.change(o,"sonspeed",1.0,0,0,"正比",12) end
end,Sonevents=function(o,t,R)
if t==(92) then R.change(o,"sonaspeed",0.005,0.002,0,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.0,0,0,"正比",80) end
if t==(1) then R.change(o,"type",1.0,1.0,1,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",0.0,10.0,1,"正比",60) end
if t==(1) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=384,["begin"]=240,["life"]=12,["fx"]=314,["fy"]=600,["r"]=20,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=239,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2) then R.change(o,"r",330.0,0,1,"正比",11) end
if t==(1) then R.change(o,"sonspeed",1.0,0,0,"正比",12) end
end,Sonevents=function(o,t,R)
if t==(92) then R.change(o,"sonaspeed",0.005,0.002,0,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.0,0,0,"正比",80) end
if t==(1) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",0.0,10.0,1,"正比",60) end
if t==(1) then R.change(o,"head",0.0,130.0,1,"正比",500) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=180,["life"]=1,["fx"]=-99998,["fy"]=80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=178,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",22.0,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",22.0,0,0,"正比",60) end
if t==(1) then R.change(o,"colorG",1.0,0,0,"正比",60) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=1,["life"]=120,["fx"]=-99998,["fy"]=80,["r"]=250,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=644,["type"]=229,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=2,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/33)*33) then R.change(o,"rdirection",360.0,0,1,"正比",33) end
if t==(1+math.floor(t/33)*33) then R.change(o,"fdirection",360.0,0,1,"正比",33) end
if t==(101) then R.change(o,"r",10.0,0,1,"正比",40) end
if t==(1) then R.change(o,"r",80.0,0,1,"正比",100) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"head",0.0,290.0,1,"正比",530) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
if t==(1) then R.change(o,"colorB",60.0,0,0,"正比",90) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",60) end
if t==(60) then R.change(o,"Blend",1.0,0,0,"正比",1) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",40) end
if t==(1) then R.change(o,"head",0.0,320.0,1,"正比",60) end
if t==(1) then R.change(o,"colorG",120.0,0,0,"正比",90) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=64,["begin"]=180,["life"]=1,["fx"]=315,["fy"]=70,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=236,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(215) then R.change(o,"sonspeed",2.0,0,0,"正比",241) end
if t==(50) then R.change(o,"sonspeed",0.1,0,0,"正比",30) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=96,["begin"]=175,["life"]=60,["fx"]=315,["fy"]=80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=6,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=70,["type"]=241,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=55,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=40,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(21) then R.change(o,"alpha",1.0,0,0,"正比",50) end
if t==(1) then R.change(o,"alpha",15.0,5.0,0,"正比",20) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=180,["life"]=1,["fx"]=-99998,["fy"]=80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=71,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=210,["type"]=229,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=185,["colorB"]=125,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,1960.0,1,"正比",360) end
if t==(1) then R.change(o,"sonspeedd",270.0,130.0,0,"正比",1) end
if t==(1) then R.change(o,"type",2.0,3.0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",6.0,4.0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["x"]=384,["y"]=224,["begin"]=1,["life"]=420,["halfw"]=700,["halfh"]=700,["Circle"]=false,["type"]=1,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(211) then R.change(o,"life",1.0,0,0,"正比",1) end
if t==(181) then R.change(o,"sonspeed",-3.0,2.0,0,"正比",1) end
if t==(181) then R.change(o,"Afterimage",1.0,0,0,"正比",1) end
if t==(181) then R.change(o,"alpha",10.0,0,0,"正比",31) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=352,["begin"]=240,["life"]=1,["fx"]=314,["fy"]=600,["r"]=20,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=11,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=550,["type"]=237,["wscale"]=0.7,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2) then R.change(o,"r",330.0,0,1,"正比",11) end
if t==(1) then R.change(o,"sonspeed",1.0,0,0,"正比",12) end
end,Sonevents=function(o,t,R)
if t==(92) then R.change(o,"sonaspeed",0.01,0.005,0,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.0,0,0,"正比",80) end
if t==(1) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",0.0,10.0,1,"正比",60) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=384,["begin"]=300,["life"]=30,["fx"]=315,["fy"]=550,["r"]=20,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=6,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=239,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=165,["colorB"]=65,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2) then R.change(o,"r",330.0,0,1,"正比",30) end
if t==(1) then R.change(o,"sonspeed",1.0,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=352,["begin"]=240,["life"]=1,["fx"]=314,["fy"]=600,["r"]=20,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=31,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=239,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2) then R.change(o,"r",330.0,0,1,"正比",11) end
if t==(1) then R.change(o,"sonspeed",1.0,0,0,"正比",12) end
end,Sonevents=function(o,t,R)
if t==(92) then R.change(o,"sonaspeed",0.01,0.005,0,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.0,0,0,"正比",80) end
if t==(1) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",0.0,10.0,1,"正比",60) end
if t==(1) then R.change(o,"head",0.0,130.0,1,"正比",500) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=384,["begin"]=282,["life"]=60,["fx"]=295,["fy"]=500,["r"]=-20,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=0,["wscale"]=2,["hscale"]=0.1,["colorR"]=255,["colorG"]=165,["colorB"]=65,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",430.0,0,1,"正比",60) end
if t==(1+math.floor(t/6)*6) then R.change(o,"rdirection",180.0,0,1,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=false,["x"]=160,["y"]=256,["begin"]=1,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=6,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=140,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=242,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=0.2,["yscale"]=2,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(1) then R.change(o,"xscale",2.0,0,0,"正比",240) end
if t==(240) then R.change(o,"sonspeed",1.0,0,1,"正比",420) end
if t==(61) then R.change(o,"Outdispel",1.0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.8,0,0,"正比",120) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=false,["x"]=256,["y"]=256,["begin"]=1,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=130,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=239,["wscale"]=2,["hscale"]=0.1,["colorR"]=255,["colorG"]=155,["colorB"]=55,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=416,["y"]=320,["begin"]=1,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=70,["type"]=224,["wscale"]=0.5,["hscale"]=1,["colorR"]=255,["colorG"]=155,["colorB"]=81,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=12,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.0,1.0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0.0,1.0,1,"正比",1) end
end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=384,["begin"]=300,["life"]=60,["fx"]=295,["fy"]=500,["r"]=-20,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=239,["wscale"]=0.5,["hscale"]=1,["colorR"]=255,["colorG"]=165,["colorB"]=65,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",430.0,0,1,"正比",60) end
if t==(1+math.floor(t/6)*6) then R.change(o,"rdirection",180.0,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(2+math.floor(t/5)*5) then R.change(o,"alpha",50.0,30.0,0,"正比",5) end
end},
{["id"]=8,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=384,["begin"]=242,["life"]=60,["fx"]=295,["fy"]=240,["r"]=-20,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=49,["wscale"]=0.1,["hscale"]=55,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=88,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"r",430.0,0,1,"正比",60) end
if t==(1+math.floor(t/6)*6) then R.change(o,"rdirection",180.0,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",3.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",60) end
end},
{["id"]=9,["parentid"]=2,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=false,["x"]=192,["y"]=256,["begin"]=1,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=6,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=130,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=246,["wscale"]=1.2,["hscale"]=1.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=0.2,["yscale"]=2,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(4+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(9+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(14+math.floor(t/20)*20) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/20)*20) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(1) then R.change(o,"xscale",2.0,0,0,"正比",600) end
if t==(250) then R.change(o,"sonspeed",1.0,0,1,"正比",420) end
if t==(61) then R.change(o,"Outdispel",1.0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.55,0.05,0,"正比",240) end
end},
{["id"]=10,["parentid"]=2,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=448,["y"]=320,["begin"]=1,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=70,["type"]=224,["wscale"]=1,["hscale"]=2,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=14,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.0,1.0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0.0,2.0,1,"正比",1) end
end},
{["id"]=11,["parentid"]=2,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=448,["y"]=288,["begin"]=1,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=225,["wscale"]=0.4,["hscale"]=1,["colorR"]=255,["colorG"]=165,["colorB"]=125,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=13,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=270,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0.0,1.0,1,"正比",1) end
end},
{["id"]=12,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=90,["life"]=45,["fx"]=315,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=15,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=49,["wscale"]=0.1,["hscale"]=55,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=60,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",18.0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",1.0,0,0,"正比",60) end
end},
{["id"]=13,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=320,["begin"]=240,["life"]=1,["fx"]=-99998,["fy"]=600,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=0,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=240,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=185,["colorB"]=125,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",5.0,0,0,"正比",60) end
if t==(3) then R.change(o,"alpha",1.0,0,0,"正比",60) end
if t==(1) then R.change(o,"colorB",1.0,0,0,"正比",60) end
if t==(1) then R.change(o,"colorG",50.0,0,0,"正比",60) end
end},
{["id"]=14,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=448,["begin"]=241,["life"]=18,["fx"]=-99998,["fy"]=490,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=231,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.8,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2.0,0,2,"正比",18) end
if t==(1) then R.change(o,"r",320.0,0,1,"正比",18) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,1200.0,1,"正比",800) end
if t==(1) then R.change(o,"type",1.0,2.0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.5,0.5,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
end},
{["id"]=15,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=416,["begin"]=241,["life"]=3,["fx"]=-99998,["fy"]=490,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=231,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2.0,0,2,"正比",3) end
if t==(1) then R.change(o,"r",20.0,0,1,"正比",3) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,1200.0,1,"正比",800) end
if t==(1) then R.change(o,"type",1.0,2.0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=128,["begin"]=1,["life"]=90,["fx"]=315,["fy"]=80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=20,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=240,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",400) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0.0,20.0,1,"正弦",400) end
if t==(1) then R.change(o,"alpha",50.0,20.0,1,"正弦",200) end
end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=128,["begin"]=91,["life"]=1,["fx"]=315,["fy"]=80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=239,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",0.6,0,0,"正比",90) end
if t==(1) then R.change(o,"wscale",0.6,0,0,"正比",90) end
if t==(1) then R.change(o,"head",0.0,60.0,1,"正比",120) end
end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=256,["y"]=128,["begin"]=180,["life"]=1,["fx"]=315,["fy"]=80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=239,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=416,["begin"]=240,["life"]=12,["fx"]=315,["fy"]=600,["r"]=10,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=237,["wscale"]=0.7,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2) then R.change(o,"r",330.0,0,1,"正比",11) end
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",12) end
end,Sonevents=function(o,t,R)
if t==(92) then R.change(o,"sonaspeed",0.003,0.001,0,"正比",61) end
if t==(2) then R.change(o,"sonspeed",0.0,0,0,"正比",80) end
if t==(1) then R.change(o,"type",1.0,1.0,1,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",0.0,10.0,1,"正比",60) end
if t==(1) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
end},
{["id"]=4,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=416,["begin"]=300,["life"]=51,["fx"]=315,["fy"]=550,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=239,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=200,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=416,["begin"]=240,["life"]=12,["fx"]=315,["fy"]=600,["r"]=30,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=240,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(2) then R.change(o,"r",330.0,0,1,"正比",11) end
if t==(1) then R.change(o,"sonspeed",0.7,0,0,"正比",12) end
end,Sonevents=function(o,t,R)
if t==(92) then R.change(o,"sonaspeed",0.005,0.001,0,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.0,0,0,"正比",80) end
if t==(1) then R.change(o,"sonspeedd",270.0,0,0,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",0.0,10.0,1,"正比",60) end
if t==(1) then R.change(o,"head",0.0,90.0,1,"正比",400) end
end}
}}
