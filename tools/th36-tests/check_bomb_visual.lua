-- 回归虚无的红色本体和白色加算辉光来自原作bullet ANM175/174，不改贴图或ECL色号。
arg={'回归虚无绘制层'}
local f=assert(io.open('tools/check_stage.lua','rb'));local setup=f:read('*a');f:close()
assert(loadstring(setup:sub(1,assert(setup:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/anm/original.lua');dofile('mod/GAME/th36.lua')
local A,H=OriginalANM,_editor_class.TH36.runtime
local checks=0
local function check(v,msg) assert(v,msg);checks=checks+1 end
local vm=A.new(11,'bullet',175)
for i=1,29 do A.step(vm) end
check(vm.render_layer==12 and #vm.children==3,'红色本体12层／三次辉光生成未执行')
check(vm.blend=='' and vm.color[1]==255 and vm.color[2]==0 and vm.color[3]==0,'红色本体必须保持原作普通透明混合')
for _,child in ipairs(vm.children) do
    check(child.render_layer==14 and child.blend=='mul+add','白色辉光必须保持原作14层加算')
    check(child.color[1]==255 and child.color[2]==255 and child.color[3]==255,'辉光不能继承本体红色')
end
local previous=A.draw_vm;local calls={}
A.draw_vm=function(v,x,y)
    if v.visible then calls[#calls+1]={vm=v,x=x,y=y} end
end
A.draw(vm,10,20)
check(calls[1].vm==vm and #calls==4,'单个炸弹必须先本体、后辉光')
local s=H.session({_live=true},4,'main')
local a=H.attach({_live=true},s,'main',0,128,100)
local b=H.attach({_live=true},s,'main',0,128,100)
a.anm[0]=vm;b.anm[0]=A.new(11,'bullet',175)
for i=1,29 do A.step(b.anm[0]) end
calls={};H.draw_actor(a);H.draw_actor(b)
check(#calls==0,'敌机本体render不能提前画12／14层')
local front,back
for _,o in ipairs(s.effects) do
    if o.plane==12 then back=o elseif o.plane==14 then front=o end
end
check(back.layer<LAYER.ENEMY_BULLET and front.layer>LAYER.ENEMY_BULLET,'两个原作特效层必须分处弹幕前后')
back.class.render(back);local boundary=#calls
front.class.render(front)
check(boundary==2 and #calls==8,'多颗炸弹必须跨敌机合并绘制层')
for i,call in ipairs(calls) do
    check(call.vm.render_layer==(i<=boundary and 12 or 14),'后一个红色本体覆盖了前一个白色辉光')
end
-- 对纯红底叠白色半透明像素，原顺序得到白亮中心；反序只会留下暗红／粉红。
local alpha=192/255;local glow=.5;local background={.1,.2,.3}
local original,reversed={},{}
for c=1,3 do
    local red=c==1 and 1 or 0
    original[c]=math.min(1,red*alpha+background[c]*(1-alpha)+glow)
    reversed[c]=red*alpha+math.min(1,background[c]+glow)*(1-alpha)
end
check(original[2]>reversed[2] and original[3]>reversed[3],'绘制顺序必须影响绿色／蓝色加算分量')
A.draw_vm=previous;H.close(s)
for _,o in ipairs(s.effects) do check(not IsValid(o),'结束后残留跨敌机绘制层') end
print(('回归虚无颜色回归通过：%d项；原作普通透明红本体＋14层白色加算辉光。'):format(checks))
