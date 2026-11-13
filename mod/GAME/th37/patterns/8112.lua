-- 离线展开：b8112.xna；事件均已编译为Lua条件和调用。
return {id="8112",total=1240,centerAvailable=true,center={315,176,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=1,["life"]=560,["fx"]=-99998,["fy"]=-99998,["r"]=30,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=12,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=350,["speed"]=0,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=228,["wscale"]=0.3,["hscale"]=0.6,["colorR"]=155,["colorG"]=55,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.3,["yscale"]=1.1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",5.0,0,0,"正比",200) end
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",60) end
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",0.5,0,1,"正弦",59) end
if t==(1+math.floor(t/60)*60) then R.change(o,"range",12.0,0,1,"正弦",59) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.1,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0.2,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",20) end
if t==(1) then R.change(o,"hscale",0.3,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=1,["life"]=360,["fx"]=-99998,["fy"]=176,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=220,["speed"]=0,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2000,["type"]=18,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=50,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=20},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(180) then R.change(o,"sonaspeed",0.0,0,0,"正比",1) end
end}
}}
