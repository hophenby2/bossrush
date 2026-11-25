-- 使用原作UI入口，确认随机模式跳过显示对象，普通练习仍会创建。
local rogue,created,attached=false,0,0
RogueEncounter={enabled=function(level)return rogue and level==39 end}
object={}
Class=function()return {}end
boss_ui={}
EISlib={Boss={path=''}}
IsValid=function(o)return o~=nil end
New=function()
    created=created+1
    return {mgr={add_object=function()attached=attached+1 end}}
end
LAYER_TOP,GROUP_GHOST=0,0
dofile('mod/GAME/ports/theis/EISlib/boss/boss_ui.lua')
rogue=true;boss_ui.init({}, {})
assert(created==0 and attached==0,'随机模式创建了原作UI显示对象')
rogue=false;boss_ui.init({}, {})
assert(created==1 and attached==1,'普通练习丢失原作UI')
rogue=true;boss_ui.init({}, {})
assert(created==1 and attached==1,'随机模式复用了旧的原作UI显示对象')
print('Rogue source UI: practice / rogue guards passed')
