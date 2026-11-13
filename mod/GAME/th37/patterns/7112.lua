-- 离线展开：b7112.xna；事件均已编译为Lua条件和调用。
return {id="7112",total=6500,centerAvailable=true,center={315,-20,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,300,300,150,280,10,0},{0,300,300,300,150,150,80,0},{300,0,300,300,150,280,10,0},{300,300,300,300,150,150,80,0},{600,0,200,200,100,100,0,0},{800,0,100,100,50,50,0,0},{600,200,100,100,50,50,1,0},{700,200,100,100,50,50,1,0},{800,200,100,100,50,50,1,0},{900,200,100,100,50,50,0,0},{600,300,100,100,50,50,0,0},{0,600,150,150,75,75,0,0},{150,600,150,150,75,75,0,0},{300,600,150,150,75,75,0,0},{450,600,150,150,75,75,0,0},{0,800,150,150,75,75,0,0},{150,800,150,150,75,75,0,0},{300,800,150,150,75,75,0,0},{450,800,150,150,75,75,0,0},{600,800,150,150,75,75,0,0},{750,800,150,150,75,75,0,0},{700,300,200,200,100,100,40,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=290,["life"]=150,["fx"]=-99998,["fy"]=-80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=50,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=10,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1+math.floor(t/220)*220) then R.change(o,"r",200.0,0,1,"正弦",219) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/70)*70) then R.change(o,"sonspeedd",0.0,4.0,1,"正弦",69) end
if t==(1+math.floor(t/70)*70) then R.change(o,"sonspeed",0.2,0,1,"正弦",69) end
if t==(1) then R.change(o,"head",0.0,60.0,1,"正比",400) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=32,["begin"]=1,["life"]=320,["fx"]=-99998,["fy"]=-80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=80,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=250,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=10,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1+math.floor(t/220)*220) then R.change(o,"r",200.0,0,1,"正弦",219) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/70)*70) then R.change(o,"sonspeedd",0.0,4.0,1,"正弦",69) end
if t==(1+math.floor(t/70)*70) then R.change(o,"sonspeed",0.2,0,1,"正弦",69) end
if t==(1) then R.change(o,"head",0.0,60.0,1,"正比",400) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=96,["begin"]=1,["life"]=6200,["fx"]=-99998,["fy"]=-40,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=234,["wscale"]=2,["hscale"]=2,["colorR"]=25,["colorG"]=1,["colorB"]=35,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=250,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=1,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2.0,0,1,"正比",180) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",15) end
if t==(45) then R.change(o,"alpha",0.0,0,0,"正比",45) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-30,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=228,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=255,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",33.0,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",33.0,0,0,"正比",120) end
if t==(61) then R.change(o,"alpha",1.0,0,0,"正比",120) end
end}
}}
