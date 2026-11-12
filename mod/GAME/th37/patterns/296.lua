-- 离线展开：b296.xna；事件均已编译为Lua条件和调用。
return {id="296",total=1500,centerAvailable=true,center={315,140,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=15,["life"]=10,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=15,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=900,["type"]=19,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=205,["colorB"]=205,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"t",1.0,0,0,"正比",1) end
if t>(1) then R.change(o,"range",30.0,0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",1.6,0,0,"正比",10) end
if t>(1) then R.change(o,"tiao",2.0,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"colorR",100.0,0,0,"正弦",59) end
if t==(1+math.floor(t/60)*60) then R.change(o,"colorG",100.0,0,0,"正弦",59) end
end}
}}
