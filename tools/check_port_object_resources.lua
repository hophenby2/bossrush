-- 图像赋值在进入引擎之前解析前缀，包含enemybase替换对象元表的路径。
local values=setmetatable({},{__mode='k'})
local function rawSet(o,k,v)values[o][k]=v end
SetAttr=rawSet;lstg={SetAttr=rawSet};empty=function()end
function Class(base,definition)
    local c={init=base and base.init or empty};for k,v in pairs(definition or {})do c[k]=v end
    c[1]=c.init;return c
end
local N=dofile('mod/GAME/ports/object_resources.lua')
local make,prepare=N.factory(function(name)return name and name:sub(1,6)~='theis/' and 'theis/'..name or name end)
local c=make(nil,{init=function(o)
    o.img='ball'
    assert(o.img=='theis/ball','初始元表未解析图像')
    setmetatable(o,{__index=function(t,k)return values[t][k]end,__newindex=function(t,k,v)SetAttr(t,k,v)end})
    o.img='star'
end})
prepare(c)
local o={};values[o]={};setmetatable(o,{__index=function(t,k)return values[t][k]end,__newindex=rawSet})
c.init(o);assert(o.img=='theis/star','enemybase替换元表后丢失前缀')
lstg.SetAttr(o,'img','theis/ball');assert(o.img=='theis/ball','显式SetAttr重复添加前缀')
AndroidPlatform={}
o.hscale,o.vscale=-.04,.04;o.a,o.b=-3.1944626569748,-4
assert(values[o].a==3.1944626569748 and values[o].b==4,'镜像半轴没有转换为非负尺寸')
assert(o.hscale==-.04 and o.vscale==.04,'半轴兼容改变了原作镜像绘制')
SetAttr(o,'a',-8);lstg.SetAttr(o,'b',-9)
assert(values[o].a==8 and values[o].b==9,'显式SetAttr没有转换镜像半轴')
AndroidPlatform=nil;o.a=-7;assert(values[o].a==-7,'改动了Sub原本接受的半轴值')
local host={};values[host]={};SetAttr(host,'img','ball');assert(values[host].img=='ball','影响了宿主图像名')
AndroidPlatform={};SetAttr(host,'a',-2);assert(values[host].a==-2,'影响了移植作品之外的属性赋值')
local rawNext={[3]=function(t) t.img='star' end,is_class=true}
local rawClass={[1]=function(t) t.img='ball';t.class=rawNext end,is_class=true}
prepare(rawClass);assert(rawClass.init==nil,'未登记的宿主回调类不应被接管')
prepare(rawClass,true);local init=rawClass[1]
prepare(rawClass,true);assert(rawClass[1]==init,'重复登记叠加了初始化包装')
local raw={};values[raw]={}
setmetatable(raw,{__index=function(t,k)return values[t][k]end,__newindex=rawSet})
rawClass[1](raw);assert(raw.img=='theis/ball','数组回调类的首次img赋值未解析')
raw.class[3](raw);assert(raw.img=='theis/star','原生换class后丢失图像命名空间')
print('作品对象初始img、元表替换、显式SetAttr与宿主隔离通过')
