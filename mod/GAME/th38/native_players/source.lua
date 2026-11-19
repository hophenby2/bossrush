-- 原作 C# 自机逻辑，由语法树导出；不可手工修改。
return function(CS)
local _ENV=setmetatable({CS=CS},{__index=CS.env})
setfenv(1,_ENV)
-- Bullet_xiaodan_lizi.cs SHA256 dd92ffeda40b66bcc39f183d7c38f71d5e377ee2630eae101a95e6b9134cb4c2
Bullet_xiaodan_lizi={__get={},__set={}}
Bullet_xiaodan_lizi.__index=function(o,k) local getter=Bullet_xiaodan_lizi.__get[k];if getter then return getter(o) end;return Bullet_xiaodan_lizi[k] end
Bullet_xiaodan_lizi.__newindex=function(o,k,v) local setter=Bullet_xiaodan_lizi.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Bullet_xiaodan_lizi.__base="MonoBehaviour"
function Bullet_xiaodan_lizi:Start()

self.sudufangxiang=CS.f(CS.invoke(Sincos,"Jiaodu_ads",(self.sudufangxiang + self.transform.rotation.eulerAngles.z)))
self.au=CS.invoke(self,"GetComponent","AudioSource")
if (not self.youdao) then
do return  end
end
local num=CS.f(100000)
if (Sincos.zhuqiang_aim == nil) then
if (Sincos.enemy ~= nil) then
for _,item in CS.each(Sincos.enemy) do
local __break1,__continue1=false,false
repeat
local num2=CS.invoke(Sincos,"Distance",item,self.transform)
if ((num2 < num) and (CS.invoke(item,"GetComponent","Enemymove").wudi_time <= 0)) then
num=CS.f(num2)
self.obj=item
end
until true
if __break1 then break end
end
end
if (Sincos.boss ~= nil) then
for _,item2 in CS.each(Sincos.boss) do
local __break2,__continue2=false,false
repeat
local num2=CS.invoke(Sincos,"Distance",item2.transform,self.transform)
if (num2 < num) then
num=CS.f(num2)
self.obj=item2.transform
end
until true
if __break2 then break end
end
end
else
self.obj=Sincos.zhuqiang_aim
end
if ((self.obj ~= nil) and (((((self.obj.position.x < CS.f(0)) or (self.obj.position.x > CS.f(9))) or (self.obj.position.y > (-CS.f(0)))) or (self.obj.position.y < (-CS.f(10)))))) then
self.obj=nil
end
end
function Bullet_xiaodan_lizi:FixedUpdate()

self.time=self.time+1
if (not self.add_reduce) then
if (self.speed < self.speed_maxmin) then
self.speed=CS.f((self.speed + self.speed_add))
end
else
if (self.speed > self.speed_maxmin) then
self.speed=CS.f((self.speed - self.speed_add))
end
end
self.yidongx=CS.f((self.speed * CS.invoke(Sincos,"Dcos",self.sudufangxiang)))
self.yidongy=CS.f((self.speed * CS.invoke(Sincos,"Dsin",self.sudufangxiang)))
self.transform.position=CS.copy((self.transform.position + CS.new("Vector3",self.yidongx,self.yidongy,CS.f(0))))
if (self.youdao and (self.obj ~= nil)) then
local num=CS.invoke(Sincos,"Distance",self.transform,self.obj)
if (num > CS.f(1)) then
num=CS.f(CS.f(1))
end
num=CS.f((num * self.youdao_beilv))
local f=CS.invoke(Mathf,"Atan2",(self.obj.position.y - self.transform.position.y),(self.obj.position.x - self.transform.position.x))
local num2=CS.invoke(Mathf,"Cos",f)
local num3=CS.invoke(Mathf,"Sin",f)
self.transform.position=CS.copy((self.transform.position + CS.new("Vector3",(num2 * num),(num3 * num),CS.f(0))))
end
if (self.time == self.baozha) then
if (self.a ~= nil) then
CS.invoke(Object,"Instantiate",self.a,self.transform.position,self.transform.rotation)
end
if (self.au ~= nil) then
CS.invoke(self.au,"Play")
end
end
if (self.time == self.timedeath) then
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
end
function Bullet_xiaodan_lizi.defaults(self)
self.sudufangxiang=0
self.speed=0
self.yidongx=0
self.yidongy=0
self.time=0
self.timedeath=0
self.baozha=0
self.a=nil
self.speed_add=0
self.speed_maxmin=0
self.add_reduce=false
self.au=nil
self.youdao=false
self.youdao_beilv=0
self.obj=nil
end
-- Bullet_xiaoshi_time.cs SHA256 6d26e664e059760ba7e46aed2a8dfb3cbd6a11db9743d53cb4b727423b80accc
Bullet_xiaoshi_time={__get={},__set={}}
Bullet_xiaoshi_time.__index=function(o,k) local getter=Bullet_xiaoshi_time.__get[k];if getter then return getter(o) end;return Bullet_xiaoshi_time[k] end
Bullet_xiaoshi_time.__newindex=function(o,k,v) local setter=Bullet_xiaoshi_time.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Bullet_xiaoshi_time.__base="MonoBehaviour"
function Bullet_xiaoshi_time:Start()

self.sr=CS.invoke(self,"GetComponent","SpriteRenderer")
end
function Bullet_xiaoshi_time:FixedUpdate()

self.time=self.time+1
if (self.time <= self.timemax) then
self.transform.localScale=CS.copy(CS.new("Vector3",(self.transform.localScale.x + self.fangda),(self.transform.localScale.y + self.fangda),(self.transform.localScale.z + self.fangda)))
end
if (self.time >= self.timeanim) then
self.sr.color=CS.new("Color",CS.f(1),CS.f(1),CS.f(1),(self.sr.color.a - CS.f(0.02)))
if (self.time == self.timedeath) then
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
end
end
function Bullet_xiaoshi_time.defaults(self)
self.time=0
self.sr=nil
self.speed=0
self.fangda=0
self.timemax=0
self.timeanim=0
self.timedeath=0
end
-- Bulletmove_jiasudu.cs SHA256 bfb73c3920bdaae4223d3f8eb8732a2428583708309d190e233fc59df2c00fd8
Bulletmove_jiasudu={__get={},__set={}}
Bulletmove_jiasudu.__index=function(o,k) local getter=Bulletmove_jiasudu.__get[k];if getter then return getter(o) end;return Bulletmove_jiasudu[k] end
Bulletmove_jiasudu.__newindex=function(o,k,v) local setter=Bulletmove_jiasudu.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Bulletmove_jiasudu.__base="MonoBehaviour"
function Bulletmove_jiasudu:Start()

self.sudufangxiang=CS.f((self.sudufangxiang + CS.invoke(Sincos,"Seedrandom",(CS.f(0) - self.sudufangxiang_add_range),self.sudufangxiang_add_range)))
self.sudufangxiang=CS.f(CS.invoke(Sincos,"Jiaodu_ads",self.sudufangxiang))
self.jiasudufangxiang=CS.f(CS.invoke(Sincos,"Jiaodu_ads",self.jiasudufangxiang))
self.sudu=CS.f((self.sudu + CS.invoke(Sincos,"Seedrandom",(CS.f(0) - self.sudu_add_range),self.sudu_add_range)))
self.yidongx=CS.f((self.sudu * CS.invoke(Sincos,"Dcos",self.sudufangxiang)))
self.yidongy=CS.f((self.sudu * CS.invoke(Sincos,"Dsin",self.sudufangxiang)))
self.dx=CS.f((self.jiasudu * CS.invoke(Sincos,"Dcos",self.jiasudufangxiang)))
self.dy=CS.f((self.jiasudu * CS.invoke(Sincos,"Dsin",self.jiasudufangxiang)))
end
function Bulletmove_jiasudu:FixedUpdate()

self.djiax=CS.f((self.djiax + self.dx))
self.djiay=CS.f((self.djiay + self.dy))
self.transform.position=CS.copy((self.transform.position + CS.new("Vector3",(self.yidongx + self.djiax),(self.yidongy + self.djiay),CS.f(0))))
end
function Bulletmove_jiasudu.defaults(self)
self.sudufangxiang=0
self.sudufangxiang_add_range=0
self.sudu=0
self.sudu_add_range=0
self.yidongx=0
self.yidongy=0
self.jiasudufangxiang=0
self.jiasudu=0
self.dx=0
self.dy=0
self.djiax=0
self.djiay=0
end
-- Bulletmove_xuanzhuan.cs SHA256 8c81794d16ee73dd5476585ba42c441a3b7271d4e6acb4a0d0912dabba255d3d
Bulletmove_xuanzhuan={__get={},__set={}}
Bulletmove_xuanzhuan.__index=function(o,k) local getter=Bulletmove_xuanzhuan.__get[k];if getter then return getter(o) end;return Bulletmove_xuanzhuan[k] end
Bulletmove_xuanzhuan.__newindex=function(o,k,v) local setter=Bulletmove_xuanzhuan.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Bulletmove_xuanzhuan.__base="MonoBehaviour"
function Bulletmove_xuanzhuan:Start()

self.sudufangxiang=CS.f(CS.invoke(Sincos,"Jiaodu_ads",(self.sudufangxiang + self.transform.rotation.eulerAngles.z)))
end
function Bulletmove_xuanzhuan:FixedUpdate()

self.time=self.time+1
self.yidongx=CS.f((self.speed * CS.invoke(Sincos,"Dcos",self.sudufangxiang)))
self.yidongy=CS.f((self.speed * CS.invoke(Sincos,"Dsin",self.sudufangxiang)))
self.transform.position=CS.copy((self.transform.position + CS.new("Vector3",self.yidongx,self.yidongy,CS.f(0))))
CS.invoke(self.transform,"Rotate",CS.f(0),CS.f(0),self.xuanzhuan)
if ((not self.chupingxiaoshi) and (((((self.transform.position.x < (-CS.f(1))) or (self.transform.position.x > CS.f(10))) or (self.transform.position.y < (-CS.f(11)))) or (self.transform.position.y > CS.f(1))))) then
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
if (self.time == self.deathtime) then
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
end
function Bulletmove_xuanzhuan.defaults(self)
self.sudufangxiang=0
self.speed=0
self.xuanzhuan=0
self.yidongx=0
self.yidongy=0
self.time=0
self.deathtime=0
self.chupingxiaoshi=false
end
-- Bulletmove_ziji_y.cs SHA256 371aae15d9395f977d8d73d44b32c806d9aef8def434b9d2ec2937578c65493d
Bulletmove_ziji_y={__get={},__set={}}
Bulletmove_ziji_y.__index=function(o,k) local getter=Bulletmove_ziji_y.__get[k];if getter then return getter(o) end;return Bulletmove_ziji_y[k] end
Bulletmove_ziji_y.__newindex=function(o,k,v) local setter=Bulletmove_ziji_y.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Bulletmove_ziji_y.__base="MonoBehaviour"
function Bulletmove_ziji_y:FixedUpdate()

self.time=self.time+1
if (self.time == self.time_death) then
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
CS.invoke(self.transform,"Translate",CS.f(0),self.speed,CS.f(0))
if (self.speed < self.speed_max) then
self.speed=CS.f((self.speed + self.speed_add))
end
if ((not self.no_chupingxiaoshi) and (((((self.transform.position.x < (-CS.f(1))) or (self.transform.position.x > CS.f(10))) or (self.transform.position.y < (-CS.f(11)))) or (self.transform.position.y > CS.f(1))))) then
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
end
function Bulletmove_ziji_y.defaults(self)
self.speed=0
self.speed_add=0
self.speed_max=0
self.no_chupingxiaoshi=false
self.time_death=0
self.time=0
end
-- Bulletmove_ziji_youdao.cs SHA256 1fa92fcf21bc4e8e1476bed6d526dc478f19c3958747cbab120315a624eac5c7
Bulletmove_ziji_youdao={__get={},__set={}}
Bulletmove_ziji_youdao.__index=function(o,k) local getter=Bulletmove_ziji_youdao.__get[k];if getter then return getter(o) end;return Bulletmove_ziji_youdao[k] end
Bulletmove_ziji_youdao.__newindex=function(o,k,v) local setter=Bulletmove_ziji_youdao.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Bulletmove_ziji_youdao.__base="MonoBehaviour"
function Bulletmove_ziji_youdao:Start()

self.speedmax=CS.f(CS.f(0.5))
self.dis=CS.f(CS.f(100000))
if (Sincos.zhuqiang_aim == nil) then
if (Sincos.enemy ~= nil) then
for _,item in CS.each(Sincos.enemy) do
local __break1,__continue1=false,false
repeat
self.dis0=CS.f(CS.invoke(Sincos,"Distance",item,self.transform))
if ((self.dis0 < self.dis) and (CS.invoke(item,"GetComponent","Enemymove").wudi_time <= 0)) then
self.dis=CS.f(self.dis0)
self.obj=item
end
until true
if __break1 then break end
end
end
if (Sincos.boss ~= nil) then
for _,item2 in CS.each(Sincos.boss) do
local __break2,__continue2=false,false
repeat
self.dis0=CS.f(CS.invoke(Sincos,"Distance",item2.transform,self.transform))
if (self.dis0 < self.dis) then
self.dis=CS.f(self.dis0)
self.obj=item2.transform
end
until true
if __break2 then break end
end
end
else
self.obj=Sincos.zhuqiang_aim
end
if ((self.obj ~= nil) and (((((self.obj.position.x < CS.f(0)) or (self.obj.position.x > CS.f(9))) or (self.obj.position.y > (-CS.f(0)))) or (self.obj.position.y < (-CS.f(10)))))) then
self.obj=nil
end
end
function Bulletmove_ziji_youdao:FixedUpdate()

if (self.obj ~= nil) then
if ((((self.obj.position.x < CS.f(0)) or (self.obj.position.x > CS.f(9))) or (self.obj.position.y > (-CS.f(0)))) or (self.obj.position.y < (-CS.f(10)))) then
self.obj=nil
else
self.jiao=CS.f(CS.invoke(Sincos,"Jiaodu_ads",(((CS.invoke(Mathf,"Atan2",(self.obj.position.y - self.transform.position.y),(self.obj.position.x - self.transform.position.x)) * CS.f(57.29578)) - self.transform.rotation.eulerAngles.z) - CS.f(90))))
if (self.jiao > CS.f(180)) then
if (self.jiao < (CS.f(360) - self.speedmax)) then
self.jiao=CS.f((CS.f(360) - self.speedmax))
end
else
if (self.jiao > self.speedmax) then
self.jiao=CS.f(self.speedmax)
end
end
CS.invoke(self.transform,"Rotate",CS.f(0),CS.f(0),self.jiao)
end
else
if (self.lk > 0) then
self.lk=self.lk-1
if (Sincos.enemy ~= nil) then
self.dis=CS.f(CS.f(100000))
for _,item in CS.each(Sincos.enemy) do
local __break3,__continue3=false,false
repeat
self.dis0=CS.f(CS.invoke(Sincos,"Distance",item,self.transform))
if ((self.dis0 < self.dis) and (CS.invoke(item,"GetComponent","Enemymove").wudi_time <= 0)) then
self.dis=CS.f(self.dis0)
self.obj=item
end
until true
if __break3 then break end
end
end
if (Sincos.boss ~= nil) then
self.dis=CS.f(CS.f(100000))
for _,item2 in CS.each(Sincos.boss) do
local __break4,__continue4=false,false
repeat
self.dis0=CS.f(CS.invoke(Sincos,"Distance",item2.transform,self.transform))
if (self.dis0 < self.dis) then
self.dis=CS.f(self.dis0)
self.obj=item2.transform
end
until true
if __break4 then break end
end
end
if ((self.obj ~= nil) and (((((self.obj.position.x < CS.f(0.5)) or (self.obj.position.x > CS.f(8.5))) or (self.obj.position.y > (-CS.f(0.5)))) or (self.obj.position.y < (-CS.f(9.5)))))) then
self.obj=nil
end
end
end
CS.invoke(self.transform,"Translate",CS.f(0),self.speed,CS.f(0))
if (self.speedmax < self.rotate_max) then
self.speedmax=CS.f((self.speedmax + self.rotate_add))
end
if (self.speed < self.speed_max) then
self.speed=CS.f((self.speed + self.speed_add))
end
if ((((self.transform.position.x < (-CS.f(1))) or (self.transform.position.x > CS.f(10))) or (self.transform.position.y < (-CS.f(11)))) or (self.transform.position.y > CS.f(1))) then
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
end
function Bulletmove_ziji_youdao.defaults(self)
self.jiao=0
self.suofang=0
self.speed=0
self.speed_add=0
self.speed_max=0
self.rotate_add=0
self.rotate_max=0
self.obj=nil
self.dis=0
self.dis0=0
self.speedmax=0
self.lk=5
end
-- Center_ziji_zhixiang.cs SHA256 8dd43b403c2d1fd2caabcb4f870d3f1288e8c97ed3c2423a11d7fcb11dfce8f8
Center_ziji_zhixiang={__get={},__set={}}
Center_ziji_zhixiang.__index=function(o,k) local getter=Center_ziji_zhixiang.__get[k];if getter then return getter(o) end;return Center_ziji_zhixiang[k] end
Center_ziji_zhixiang.__newindex=function(o,k,v) local setter=Center_ziji_zhixiang.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Center_ziji_zhixiang.__base="MonoBehaviour"
function Center_ziji_zhixiang:Start()


end
function Center_ziji_zhixiang:FixedUpdate()

if Sincos.anjian_now[2] then
if (Sincos.ziji_zhixiang > CS.f(0)) then
Sincos.ziji_zhixiang=CS.f(0)
end
if (Sincos.ziji_zhixiang > (CS.f(0) - self.zhixiang_max)) then
Sincos.ziji_zhixiang=(Sincos.ziji_zhixiang - self.zhixiang_changespeed)
else
Sincos.ziji_zhixiang=(CS.f(0) - self.zhixiang_max)
end
do return  end
end
if (Sincos.ziji_zhixiang < CS.f(0)) then
Sincos.ziji_zhixiang=CS.f(0)
end
if Sincos.anjian_now[3] then
if (Sincos.ziji_zhixiang < self.zhixiang_max) then
Sincos.ziji_zhixiang=(Sincos.ziji_zhixiang + self.zhixiang_changespeed)
else
Sincos.ziji_zhixiang=self.zhixiang_max
end
else
if (CS.invoke(Mathf,"Abs",Sincos.ziji_zhixiang) < CS.f(2)) then
Sincos.ziji_zhixiang=CS.f(0)
else
if (Sincos.ziji_zhixiang < CS.f(0)) then
Sincos.ziji_zhixiang=(Sincos.ziji_zhixiang + self.zhixiang_changespeed)
else
if (Sincos.ziji_zhixiang > CS.f(0)) then
Sincos.ziji_zhixiang=(Sincos.ziji_zhixiang - self.zhixiang_changespeed)
end
end
end
end
end
function Center_ziji_zhixiang.defaults(self)
self.zhixiang_max=0
self.zhixiang_changespeed=0
end
-- Damage1.cs SHA256 14a3937772e743dd9db07c2b1b494e477b2ab756c5fba8e1fea0e69b37f3d601
Damage1={__get={},__set={}}
Damage1.__index=function(o,k) local getter=Damage1.__get[k];if getter then return getter(o) end;return Damage1[k] end
Damage1.__newindex=function(o,k,v) local setter=Damage1.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Damage1.__base="MonoBehaviour"
function Damage1:FixedUpdate()

if (self.damage <= 0) then
do return  end
end
do
local num=(Sincos.enemy.Count - 1)
while (num >= 0) do
local __break1,__continue1=false,false
repeat
self.bm=CS.invoke(Sincos.enemy[num],"GetComponent","Enemymove")
if ((((((Sincos.enemy[num].position.x - self.transform.position.x)) * ((Sincos.enemy[num].position.x - self.transform.position.x))) + (((Sincos.enemy[num].position.y - self.transform.position.y)) * ((Sincos.enemy[num].position.y - self.transform.position.y)))) < (((self.damage_r + self.bm.sdbj)) * ((self.damage_r + self.bm.sdbj)))) and (not self.bm.panding_off)) then
if ((self.bm.wudi_time <= 0) and (not self.bm.zidanwudi)) then
self.bm.life=(self.bm.life - self.damage)
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
if self.reset_aim then
Sincos.zhuqiang_aim=self.bm.transform
end
if self.add_jiejie then
Sincos.jiejiefanghu_val=(Sincos.jiejiefanghu_val + 50)
if (Sincos.jiejiefanghu_val > 299999) then
Sincos.jiejiefanghu_val=299999
end
end
end
if (Sincos.effect_cut < 2) then
CS.invoke(Object,"Instantiate",self.a,self.transform.position,self.transform.rotation)
end
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
__break1=true;break
end
until true
if __break1 then break end
num=num-1
end
end
local num2=(Sincos.boss.Count - 1)
while true do
local __break2,__continue2=false,false
repeat
if (num2 >= 0) then
self.bm2=CS.invoke(Sincos.boss[num2],"GetComponent","Bossmove")
if (((((Sincos.boss[num2].transform.position.x - self.transform.position.x)) * ((Sincos.boss[num2].transform.position.x - self.transform.position.x))) + (((Sincos.boss[num2].transform.position.y - self.transform.position.y)) * ((Sincos.boss[num2].transform.position.y - self.transform.position.y)))) < (((self.damage_r + self.bm2.sdbj)) * ((self.damage_r + self.bm2.sdbj)))) then
__break2=true;break
end
num2=num2-1
__continue2=true;break
end
do return  end
until true
if __break2 then break end
end
if ((self.bm2.wudi_time <= 0) and (not self.bm2.zidanwudi)) then
self.bm2.life=(self.bm2.life - self.damage)
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
if self.reset_aim then
Sincos.zhuqiang_aim=self.bm2.transform
end
if self.add_jiejie then
Sincos.jiejiefanghu_val=(Sincos.jiejiefanghu_val + 50)
if (Sincos.jiejiefanghu_val > 299999) then
Sincos.jiejiefanghu_val=299999
end
end
if ((self.bm2.life < 1200) and self.bm2.xuruo) then
Sincos.se_enemy_hurt_count=Sincos.se_enemy_hurt_count+1
end
end
if (Sincos.effect_cut < 2) then
CS.invoke(Object,"Instantiate",self.a,self.transform.position,self.transform.rotation)
end
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
function Damage1.defaults(self)
self.damage=0
self.damage_r=0
self.bm=nil
self.bm2=nil
self.a=nil
self.add_jiejie=false
self.reset_aim=false
end
-- Damage4.cs SHA256 802b8f00b7100d8699cd4743b019a6d96694dc0e04131697a6aabf6f33559c55
Damage4={__get={},__set={}}
Damage4.__index=function(o,k) local getter=Damage4.__get[k];if getter then return getter(o) end;return Damage4[k] end
Damage4.__newindex=function(o,k,v) local setter=Damage4.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Damage4.__base="MonoBehaviour"
function Damage4:Start()

self.au=CS.invoke(self,"GetComponent","AudioSource")
if (self.transform.parent ~= nil) then
self.speed=CS.invoke(self.transform.parent,"GetComponent","Bullet_xiaodan_lizi")
else
self.speed=CS.invoke(self.transform,"GetComponent","Bullet_xiaodan_lizi")
end
self.range=CS.f(self.damage_r)
end
function Damage4:FixedUpdate()

if (self.time_max < 0) then
do return  end
end
self.time_max=self.time_max-1
if (self.a > 0) then
self.a=self.a-1
do return  end
end
self.a=self.damage_jiange
if self.r_x_scale_x then
self.range=CS.f((self.damage_r * self.transform.localScale.x))
end
if (self.damage > 0) then
for _,item in CS.each(Sincos.enemy) do
local __break1,__continue1=false,false
repeat
self.bm=CS.invoke(item,"GetComponent","Enemymove")
if ((((((((item.position.x - self.transform.position.x)) * ((item.position.x - self.transform.position.x))) + (((item.position.y - self.transform.position.y)) * ((item.position.y - self.transform.position.y)))) < (((self.range + self.bm.sdbj)) * ((self.range + self.bm.sdbj)))) and (not self.bm.panding_off)) and (self.bm.wudi_time <= 0)) and (not self.bm.zidanwudi)) then
self.bm.life=(self.bm.life - self.damage)
if (self.au ~= nil) then
CS.invoke(self.au,"Play")
end
if ((Sincos.effect_cut < 2) and (self.damage_texiao ~= nil)) then
self.bili=CS.f((self.bm.sdbj / CS.invoke(Sincos,"Distance",CS.new("Vector2",item.position.x,item.position.y),CS.new("Vector2",self.transform.position.x,self.transform.position.y))))
self.dx=CS.f((((self.transform.position.x - item.position.x)) * self.bili))
self.dy=CS.f((((self.transform.position.y - item.position.y)) * self.bili))
CS.invoke(Object,"Instantiate",self.damage_texiao,CS.new("Vector3",(item.position.x + self.dx),(item.position.y + self.dy),CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),(-CS.f(30))))
end
if ((self.speed ~= nil) and (self.speed.speed > self.speed_min)) then
self.speed.speed=CS.f((self.speed.speed - self.speed_reduce))
end
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
end
until true
if __break1 then break end
end
for _,item2 in CS.each(Sincos.boss) do
local __break2,__continue2=false,false
repeat
self.bm2=CS.invoke(item2,"GetComponent","Bossmove")
if (((((((item2.transform.position.x - self.transform.position.x)) * ((item2.transform.position.x - self.transform.position.x))) + (((item2.transform.position.y - self.transform.position.y)) * ((item2.transform.position.y - self.transform.position.y)))) < (((self.range + self.bm2.sdbj)) * ((self.range + self.bm2.sdbj)))) and (self.bm2.wudi_time <= 0)) and (not self.bm2.zidanwudi)) then
self.bm2.life=(self.bm2.life - self.damage)
if (self.au ~= nil) then
CS.invoke(self.au,"Play")
end
if ((Sincos.effect_cut < 2) and (self.damage_texiao ~= nil)) then
self.bili=CS.f((self.bm2.sdbj / CS.invoke(Sincos,"Distance",CS.new("Vector2",item2.transform.position.x,item2.transform.position.y),CS.new("Vector2",self.transform.position.x,self.transform.position.y))))
self.dx=CS.f((((self.transform.position.x - item2.transform.position.x)) * self.bili))
self.dy=CS.f((((self.transform.position.y - item2.transform.position.y)) * self.bili))
CS.invoke(Object,"Instantiate",self.damage_texiao,CS.new("Vector3",(item2.transform.position.x + self.dx),(item2.transform.position.y + self.dy),CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),(-CS.f(30))))
CS.invoke(Object,"Instantiate",self.damage_texiao,CS.new("Vector3",(item2.transform.position.x + self.dx),(item2.transform.position.y + self.dy),CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(60)))
end
if ((self.speed ~= nil) and (self.speed.speed > self.speed_min)) then
self.speed.speed=CS.f((self.speed.speed - self.speed_reduce))
end
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
if ((self.bm2.life < 1200) and self.bm2.xuruo) then
Sincos.se_enemy_hurt_count=Sincos.se_enemy_hurt_count+1
end
end
until true
if __break2 then break end
end
end
end
function Damage4.defaults(self)
self.damage=0
self.damage_r=0
self.speed_min=0
self.speed_reduce=0
self.r_x_scale_x=false
self.range=0
self.bm=nil
self.bm2=nil
self.speed=nil
self.a=0
self.damage_jiange=0
self.damage_texiao=nil
self.bili=0
self.dx=0
self.dy=0
self.time_max=0
self.au=nil
end
-- Damage4_5.cs SHA256 13948af0030ba45605fa93daaf2934463493fd1fa12bda9ddcaaaabf78b0dab4
Damage4_5={__get={},__set={}}
Damage4_5.__index=function(o,k) local getter=Damage4_5.__get[k];if getter then return getter(o) end;return Damage4_5[k] end
Damage4_5.__newindex=function(o,k,v) local setter=Damage4_5.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Damage4_5.__base="MonoBehaviour"
function Damage4_5:FixedUpdate()

if (self.a > 0) then
self.a=self.a-1
do return  end
end
self.a=self.damage_jiange
if self.r_x_scale_x then
self.range=CS.f((self.damage_r * self.transform.localScale.x))
end
if (self.damage > 0) then
for _,item in CS.each(Sincos.enemy) do
local __break1,__continue1=false,false
repeat
self.bm=CS.invoke(item,"GetComponent","Enemymove")
if (((((((((item.position.x - self.transform.position.x)) * ((item.position.x - self.transform.position.x))) + (((item.position.y - self.transform.position.y)) * ((item.position.y - self.transform.position.y)))) < (((self.range + self.bm.sdbj)) * ((self.range + self.bm.sdbj)))) and (not self.bm.panding_off)) and (self.bm.wudi_time <= 0)) and (not self.bm.zidanwudi)) and (Sincos.dam4_5_chengfa < self.dam_max)) then
self.bm.life=(self.bm.life - self.damage)
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
Sincos.dam4_5_chengfa=(Sincos.dam4_5_chengfa + self.damage)
end
until true
if __break1 then break end
end
for _,item2 in CS.each(Sincos.boss) do
local __break2,__continue2=false,false
repeat
self.bm2=CS.invoke(item2,"GetComponent","Bossmove")
if ((((((((item2.transform.position.x - self.transform.position.x)) * ((item2.transform.position.x - self.transform.position.x))) + (((item2.transform.position.y - self.transform.position.y)) * ((item2.transform.position.y - self.transform.position.y)))) < (((self.range + self.bm2.sdbj)) * ((self.range + self.bm2.sdbj)))) and (self.bm2.wudi_time <= 0)) and (not self.bm2.zidanwudi)) and (Sincos.dam4_5_chengfa < self.dam_max)) then
self.bm2.life=(self.bm2.life - self.damage)
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
Sincos.dam4_5_chengfa=(Sincos.dam4_5_chengfa + self.damage)
if ((self.bm2.life < 1200) and self.bm2.xuruo) then
Sincos.se_enemy_hurt_count=Sincos.se_enemy_hurt_count+1
end
end
until true
if __break2 then break end
end
end
end
function Damage4_5.defaults(self)
self.damage=0
self.damage_r=0
self.damage_jiange=0
self.r_x_scale_x=false
self.dam_max=0
self.range=0
self.bm=nil
self.bm2=nil
self.a=0
end
-- Damage5.cs SHA256 ec3f24808e9139fb63b7dffcc2a58d5c17cbf7f6a98e610cc880714ee8ed53a3
Damage5={__get={},__set={}}
Damage5.__index=function(o,k) local getter=Damage5.__get[k];if getter then return getter(o) end;return Damage5[k] end
Damage5.__newindex=function(o,k,v) local setter=Damage5.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Damage5.__base="MonoBehaviour"
function Damage5:Start()

self.au=CS.invoke(self,"GetComponent","AudioSource")
end
function Damage5:FixedUpdate()

if (self.time_max < 0) then
do return  end
end
self.time_max=self.time_max-1
if (self.a > 0) then
self.a=self.a-1
do return  end
end
self.a=self.damage_jiange
if (self.damage > 0) then
for _,item in CS.each(Sincos.enemy) do
local __break1,__continue1=false,false
repeat
self.bm=CS.invoke(item,"GetComponent","Enemymove")
if (((((((((item.position.x - self.transform.position.x)) * ((item.position.x - self.transform.position.x))) + (((item.position.y - self.transform.position.y)) * ((item.position.y - self.transform.position.y)))) < (((self.damage_r_wai + self.bm.sdbj)) * ((self.damage_r_wai + self.bm.sdbj)))) and (not self.bm.panding_off)) and (((((item.position.x - self.transform.position.x)) * ((item.position.x - self.transform.position.x))) + (((item.position.y - self.transform.position.y)) * ((item.position.y - self.transform.position.y)))) > (((self.damage_r_nei + self.bm.sdbj)) * ((self.damage_r_nei + self.bm.sdbj))))) and (self.bm.wudi_time <= 0)) and (not self.bm.zidanwudi)) then
self.bm.life=(self.bm.life - self.damage)
if (self.au ~= nil) then
CS.invoke(self.au,"Play")
end
if ((Sincos.effect_cut < 2) and (self.damage_texiao ~= nil)) then
self.dis=CS.f(CS.invoke(Sincos,"Distance",CS.new("Vector2",item.position.x,item.position.y),CS.new("Vector2",self.transform.position.x,self.transform.position.y)))
if ((self.dis + self.bm.sdbj) < self.damage_r_wai) then
self.bili=CS.f((((self.dis + self.bm.sdbj)) / self.dis))
else
self.bili=CS.f((self.damage_r_wai / self.dis))
end
self.dx=CS.f((((self.transform.position.x - item.position.x)) * self.bili))
self.dy=CS.f((((self.transform.position.y - item.position.y)) * self.bili))
CS.invoke(Object,"Instantiate",self.damage_texiao,CS.new("Vector3",(self.transform.position.x - self.dx),(self.transform.position.y - self.dy),CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(30)))
end
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
end
until true
if __break1 then break end
end
for _,item2 in CS.each(Sincos.boss) do
local __break2,__continue2=false,false
repeat
self.bm2=CS.invoke(item2,"GetComponent","Bossmove")
if ((((((((item2.transform.position.x - self.transform.position.x)) * ((item2.transform.position.x - self.transform.position.x))) + (((item2.transform.position.y - self.transform.position.y)) * ((item2.transform.position.y - self.transform.position.y)))) < (((self.damage_r_wai + self.bm2.sdbj)) * ((self.damage_r_wai + self.bm2.sdbj)))) and (((((item2.transform.position.x - self.transform.position.x)) * ((item2.transform.position.x - self.transform.position.x))) + (((item2.transform.position.y - self.transform.position.y)) * ((item2.transform.position.y - self.transform.position.y)))) > (((self.damage_r_nei + self.bm2.sdbj)) * ((self.damage_r_nei + self.bm2.sdbj))))) and (self.bm2.wudi_time <= 0)) and (not self.bm2.zidanwudi)) then
self.bm2.life=(self.bm2.life - self.damage)
if (self.au ~= nil) then
CS.invoke(self.au,"Play")
end
if ((Sincos.effect_cut < 2) and (self.damage_texiao ~= nil)) then
self.dis=CS.f(CS.invoke(Sincos,"Distance",CS.new("Vector2",item2.transform.position.x,item2.transform.position.y),CS.new("Vector2",self.transform.position.x,self.transform.position.y)))
if ((self.dis + self.bm2.sdbj) < self.damage_r_wai) then
self.bili=CS.f((((self.dis + self.bm2.sdbj)) / self.dis))
else
self.bili=CS.f((self.damage_r_wai / self.dis))
end
self.dx=CS.f((((self.transform.position.x - item2.transform.position.x)) * self.bili))
self.dy=CS.f((((self.transform.position.y - item2.transform.position.y)) * self.bili))
CS.invoke(Object,"Instantiate",self.damage_texiao,CS.new("Vector3",(self.transform.position.x - self.dx),(self.transform.position.y - self.dy),CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(30)))
CS.invoke(Object,"Instantiate",self.damage_texiao,CS.new("Vector3",(self.transform.position.x - self.dx),(self.transform.position.y - self.dy),CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(120)))
end
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
if ((self.bm2.life < 1200) and self.bm2.xuruo) then
Sincos.se_enemy_hurt_count=Sincos.se_enemy_hurt_count+1
end
end
until true
if __break2 then break end
end
end
end
function Damage5.defaults(self)
self.damage=0
self.damage_r_wai=0
self.damage_r_nei=0
self.bm=nil
self.bm2=nil
self.a=0
self.damage_texiao=nil
self.bili=0
self.dis=0
self.dx=0
self.dy=0
self.au=nil
self.damage_jiange=0
self.time_max=0
end
-- Damage5_5.cs SHA256 7006986f128b37b58290df1e57c3cf2e322f1d09eb0d652f13c9af976c01d831
Damage5_5={__get={},__set={}}
Damage5_5.__index=function(o,k) local getter=Damage5_5.__get[k];if getter then return getter(o) end;return Damage5_5[k] end
Damage5_5.__newindex=function(o,k,v) local setter=Damage5_5.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Damage5_5.__base="MonoBehaviour"
function Damage5_5:FixedUpdate()

if (self.a > 0) then
self.a=self.a-1
do return  end
end
self.a=self.damage_jiange
if (self.damage > 0) then
for _,item in CS.each(Sincos.enemy) do
local __break1,__continue1=false,false
repeat
self.bm=CS.invoke(item,"GetComponent","Enemymove")
if ((((((((item.position.x - self.transform.position.x)) * ((item.position.x - self.transform.position.x))) + (((item.position.y - self.transform.position.y)) * ((item.position.y - self.transform.position.y)))) < (((self.damage_r_wai + self.bm.sdbj)) * ((self.damage_r_wai + self.bm.sdbj)))) and (not self.bm.panding_off)) and (self.bm.wudi_time <= 0)) and (not self.bm.zidanwudi)) then
self.bm.life=(self.bm.life - self.damage)
if (self.texiao ~= nil) then
local num=CS.invoke(Sincos,"Distance",CS.new("Vector2",item.position.x,item.position.y),CS.new("Vector2",self.transform.position.x,self.transform.position.y))
if (num == CS.f(0)) then
self.bili=CS.f(CS.f(0))
else
self.bili=CS.f((self.bm.sdbj / num))
end
self.dx=CS.f((((self.transform.position.x - item.position.x)) * self.bili))
self.dy=CS.f((((self.transform.position.y - item.position.y)) * self.bili))
if (Sincos.effect_cut < 2) then
CS.invoke(Object,"Instantiate",self.texiao,CS.new("Vector3",(item.position.x + self.dx),(item.position.y + self.dy),CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),(-CS.f(30))))
end
end
if (self.au ~= nil) then
CS.invoke(self.au,"Play")
end
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
end
until true
if __break1 then break end
end
for _,item2 in CS.each(Sincos.boss) do
local __break2,__continue2=false,false
repeat
self.bm2=CS.invoke(item2,"GetComponent","Bossmove")
if (((((((item2.transform.position.x - self.transform.position.x)) * ((item2.transform.position.x - self.transform.position.x))) + (((item2.transform.position.y - self.transform.position.y)) * ((item2.transform.position.y - self.transform.position.y)))) < (((self.damage_r_wai + self.bm2.sdbj)) * ((self.damage_r_wai + self.bm2.sdbj)))) and (self.bm2.wudi_time <= 0)) and (not self.bm2.zidanwudi)) then
self.bm2.life=(self.bm2.life - self.damage)
if (self.texiao ~= nil) then
local num2=CS.invoke(Sincos,"Distance",CS.new("Vector2",item2.transform.position.x,item2.transform.position.y),CS.new("Vector2",self.transform.position.x,self.transform.position.y))
if (num2 == CS.f(0)) then
self.bili=CS.f(CS.f(0))
else
self.bili=CS.f((self.bm2.sdbj / num2))
end
self.dx=CS.f((((self.transform.position.x - item2.transform.position.x)) * self.bili))
self.dy=CS.f((((self.transform.position.y - item2.transform.position.y)) * self.bili))
if (Sincos.effect_cut < 2) then
CS.invoke(Object,"Instantiate",self.texiao,CS.new("Vector3",(item2.transform.position.x + self.dx),(item2.transform.position.y + self.dy),CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),(-CS.f(30))))
CS.invoke(Object,"Instantiate",self.texiao,CS.new("Vector3",(item2.transform.position.x + self.dx),(item2.transform.position.y + self.dy),CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(60)))
end
end
if (self.au ~= nil) then
CS.invoke(self.au,"Play")
end
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
if (((self.bm2.life < 1200) and self.bm2.xuruo) and (self.damage ~= 0)) then
Sincos.se_enemy_hurt_count=Sincos.se_enemy_hurt_count+1
end
end
until true
if __break2 then break end
end
end
end
function Damage5_5.defaults(self)
self.damage=0
self.damage_r_wai=0
self.bm=nil
self.bm2=nil
self.damage_jiange=0
self.a=0
self.texiao=nil
self.bili=0
self.dx=0
self.dy=0
self.au=nil
end
-- Damage7.cs SHA256 f00409f999b0fccfb29a32cd9bffed86df8a62b0f36afa9c8a0c4204a380cded
Damage7={__get={},__set={}}
Damage7.__index=function(o,k) local getter=Damage7.__get[k];if getter then return getter(o) end;return Damage7[k] end
Damage7.__newindex=function(o,k,v) local setter=Damage7.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Damage7.__base="MonoBehaviour"
function Damage7:FixedUpdate()

if (self.a > 0) then
self.a=self.a-1
do return  end
end
self.a=3
if ((self.damage_chengfa > 0) and (self.aa == 0)) then
self.aa=5
end
self.damage_chengfa=0
if (self.damage > 0) then
self.sudufangxiang=CS.f(self.transform.rotation.eulerAngles.z)
self.dingdian_a=CS.copy(CS.new("Vector3",(self.transform.position.x + (self.laser_long_half * CS.invoke(Sincos,"Dcos",self.sudufangxiang))),(self.transform.position.y + (self.laser_long_half * CS.invoke(Sincos,"Dsin",self.sudufangxiang))),CS.f(0)))
self.dingdian_b=CS.copy(CS.new("Vector3",(self.transform.position.x - (self.laser_long_half * CS.invoke(Sincos,"Dcos",self.sudufangxiang))),(self.transform.position.y - (self.laser_long_half * CS.invoke(Sincos,"Dsin",self.sudufangxiang))),CS.f(0)))
if (self.aa > 0) then
self.aa=self.aa-1
end
for _,item in CS.each(Sincos.enemy) do
local __break1,__continue1=false,false
repeat
self.bm=CS.invoke(item,"GetComponent","Enemymove")
if ((CS.invoke(Sincos,"DistanceLine",self.dingdian_a,self.dingdian_b,CS.new("Vector2",item.position.x,item.position.y)) < (self.bm.sdbj + self.damage_r)) and (not self.bm.panding_off)) then
local num=(item.position.y - CS.invoke(Mathf,"Pow",(CS.invoke(Mathf,"Pow",(self.bm.sdbj + self.damage_r),CS.f(2)) - CS.invoke(Mathf,"Pow",CS.invoke(Mathf,"Abs",(self.transform.position.x - item.position.x)),CS.f(2))),CS.f(0.5)))
if (num < (self.transform.position.y - CS.f(4.9))) then
num=CS.f((self.transform.position.y - CS.f(4.9)))
end
if ((self.bm.wudi_time <= 0) and (not self.bm.zidanwudi)) then
self.bm.life=(self.bm.life - self.damage)
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
self.damage_chengfa=self.damage_chengfa+1
if (Sincos.effect_cut < 2) then
if self.switch_baozou then
if (self.aa == 0) then
CS.invoke(Object,"Instantiate",self.laser_deathB,CS.new("Vector3",self.transform.position.x,num,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.invoke(UnityEngine.Random,"Range",0,360))).transform.parent=self.transform
end
else
if (self.aa == 0) then
CS.invoke(Object,"Instantiate",self.laser_deathA,CS.new("Vector3",self.transform.position.x,num,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.invoke(UnityEngine.Random,"Range",0,360))).transform.parent=self.transform
end
end
end
end
self.color_blue=5
end
until true
if __break1 then break end
end
for _,item2 in CS.each(Sincos.boss) do
local __break2,__continue2=false,false
repeat
self.bm2=CS.invoke(item2,"GetComponent","Bossmove")
if (CS.invoke(Sincos,"DistanceLine",self.dingdian_a,self.dingdian_b,CS.new("Vector2",item2.transform.position.x,item2.transform.position.y)) < (self.bm2.sdbj + self.damage_r)) then
local num2=(item2.transform.position.y - CS.invoke(Mathf,"Pow",(CS.invoke(Mathf,"Pow",(self.bm2.sdbj + self.damage_r),CS.f(2)) - CS.invoke(Mathf,"Pow",CS.invoke(Mathf,"Abs",(self.transform.position.x - item2.transform.position.x)),CS.f(2))),CS.f(0.5)))
if (num2 < (self.transform.position.y - CS.f(4.9))) then
num2=CS.f((self.transform.position.y - CS.f(4.9)))
end
if ((self.bm2.wudi_time <= 0) and (not self.bm2.zidanwudi)) then
self.bm2.life=(self.bm2.life - self.damage)
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
if ((self.bm2.life < 1200) and self.bm2.xuruo) then
Sincos.se_enemy_hurt_count=Sincos.se_enemy_hurt_count+1
end
self.damage_chengfa=self.damage_chengfa+1
if (Sincos.effect_cut < 2) then
if self.switch_baozou then
if (self.aa == 0) then
CS.invoke(Object,"Instantiate",self.laser_deathB,CS.new("Vector3",self.transform.position.x,num2,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.invoke(UnityEngine.Random,"Range",0,360))).transform.parent=self.transform
end
else
if (self.aa == 0) then
CS.invoke(Object,"Instantiate",self.laser_deathA,CS.new("Vector3",self.transform.position.x,num2,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.invoke(UnityEngine.Random,"Range",0,360))).transform.parent=self.transform
end
end
end
end
self.color_blue=5
end
until true
if __break2 then break end
end
if (self.color_blue > 0) then
self.color_blue=self.color_blue-1
end
end
end
function Damage7.defaults(self)
self.damage=0
self.damage_r=0
self.laser_long_half=0
self.bm=nil
self.bm2=nil
self.a=0
self.aa=0
self.dingdian_a=CS.Vector2()
self.dingdian_b=CS.Vector2()
self.color_blue=0
self.sudufangxiang=0
self.laser_deathA=nil
self.laser_deathB=nil
self.laser_deathC=nil
self.switch_baozou=false
self.damage_chengfa=0
end
-- Damage7_2.cs SHA256 e5fe52861c4ba06ab3ddb801ee958d26c71be6de645b1e30c0ab699f8c525100
Damage7_2={__get={},__set={}}
Damage7_2.__index=function(o,k) local getter=Damage7_2.__get[k];if getter then return getter(o) end;return Damage7_2[k] end
Damage7_2.__newindex=function(o,k,v) local setter=Damage7_2.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Damage7_2.__base="MonoBehaviour"
function Damage7_2:FixedUpdate()

if (self.time_max < 0) then
do return  end
end
self.time_max=self.time_max-1
if (self.a > 0) then
self.a=self.a-1
do return  end
end
self.a=self.damage_jiange
if (self.damage > 0) then
self.sudufangxiang=CS.f(self.transform.rotation.eulerAngles.z)
self.dingdian_a=CS.copy(self.transform.position)
self.dingdian_b=CS.copy(CS.new("Vector3",(self.transform.position.x + (self.chang * CS.invoke(Sincos,"Dcos",self.sudufangxiang))),(self.transform.position.y + (self.chang * CS.invoke(Sincos,"Dsin",self.sudufangxiang))),CS.f(0)))
for _,item in CS.each(Sincos.enemy) do
local __break1,__continue1=false,false
repeat
self.bm=CS.invoke(item,"GetComponent","Enemymove")
if ((((CS.invoke(Sincos,"DistanceLine",self.dingdian_a,self.dingdian_b,CS.new("Vector2",item.position.x,item.position.y)) < (self.bm.sdbj + self.kuan)) and (not self.bm.panding_off)) and (self.bm.wudi_time <= 0)) and (not self.bm.zidanwudi)) then
self.bm.life=(self.bm.life - self.damage)
self.l=CS.f(CS.invoke(Mathf,"Sqrt",(CS.invoke(Mathf,"Pow",(self.bm.sdbj + self.kuan),CS.f(2)) - CS.invoke(Mathf,"Pow",CS.invoke(Sincos,"DistanceLine",self.dingdian_a,self.dingdian_b,item.position),CS.f(2)))))
self.chuidian=CS.copy(CS.invoke(Sincos,"Point_to_line_Chuidianzuobiao",item.position,self.dingdian_a,self.dingdian_b))
self.p_texiao=CS.copy(CS.new("Vector3",(self.chuidian.x - (self.l * CS.invoke(Sincos,"Dcos",self.sudufangxiang))),(self.chuidian.y - (self.l * CS.invoke(Sincos,"Dsin",self.sudufangxiang))),CS.f(0)))
if (Sincos.effect_cut < 2) then
CS.invoke(Object,"Instantiate",self.texiao,self.p_texiao,CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),(-CS.f(30))))
end
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
end
until true
if __break1 then break end
end
for _,item2 in CS.each(Sincos.boss) do
local __break2,__continue2=false,false
repeat
self.bm2=CS.invoke(item2,"GetComponent","Bossmove")
if (((CS.invoke(Sincos,"DistanceLine",self.dingdian_a,self.dingdian_b,CS.new("Vector2",item2.transform.position.x,item2.transform.position.y)) < (self.bm2.sdbj + self.kuan)) and (self.bm2.wudi_time <= 0)) and (not self.bm2.zidanwudi)) then
self.bm2.life=(self.bm2.life - self.damage)
self.l=CS.f(CS.invoke(Mathf,"Sqrt",(CS.invoke(Mathf,"Pow",(self.bm2.sdbj + self.kuan),CS.f(2)) - CS.invoke(Mathf,"Pow",CS.invoke(Sincos,"DistanceLine",self.dingdian_a,self.dingdian_b,item2.transform.position),CS.f(2)))))
self.chuidian=CS.copy(CS.invoke(Sincos,"Point_to_line_Chuidianzuobiao",item2.transform.position,self.dingdian_a,self.dingdian_b))
self.p_texiao=CS.copy(CS.new("Vector3",(self.chuidian.x - (self.l * CS.invoke(Sincos,"Dcos",self.sudufangxiang))),(self.chuidian.y - (self.l * CS.invoke(Sincos,"Dsin",self.sudufangxiang))),CS.f(0)))
if (Sincos.effect_cut < 2) then
CS.invoke(Object,"Instantiate",self.texiao,self.p_texiao,CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),(-CS.f(30))))
CS.invoke(Object,"Instantiate",self.texiao,self.p_texiao,CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(60)))
end
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
if ((self.bm2.life < 1200) and self.bm2.xuruo) then
Sincos.se_enemy_hurt_count=Sincos.se_enemy_hurt_count+1
end
end
until true
if __break2 then break end
end
end
end
function Damage7_2.defaults(self)
self.damage=0
self.chang=0
self.kuan=0
self.dingdian_a=CS.Vector2()
self.dingdian_b=CS.Vector2()
self.sudufangxiang=0
self.l=0
self.chuidian=CS.Vector2()
self.p_texiao=CS.Vector3()
self.bm=nil
self.bm2=nil
self.damage_jiange=0
self.a=0
self.texiao=nil
self.time_max=0
end
-- Damage7_5.cs SHA256 4a1a448b98d96402056bdf81d8756d3fa9f5aed7d02cf37861a02ffeac8e9e18
Damage7_5={__get={},__set={}}
Damage7_5.__index=function(o,k) local getter=Damage7_5.__get[k];if getter then return getter(o) end;return Damage7_5[k] end
Damage7_5.__newindex=function(o,k,v) local setter=Damage7_5.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Damage7_5.__base="MonoBehaviour"
function Damage7_5:FixedUpdate()

if (self.a > 0) then
self.a=self.a-1
do return  end
end
self.a=3
if ((self.damage_chengfa > 0) and (self.aa == 0)) then
self.aa=5
end
self.damage_chengfa=0
if (self.damage > 0) then
self.sudufangxiang=CS.f(self.transform.rotation.eulerAngles.z)
self.dingdian_a=CS.copy(CS.new("Vector3",(self.transform.position.x + (self.laser_long_half * CS.invoke(Sincos,"Dcos",self.sudufangxiang))),(self.transform.position.y + (self.laser_long_half * CS.invoke(Sincos,"Dsin",self.sudufangxiang))),CS.f(0)))
self.dingdian_b=CS.copy(CS.new("Vector3",(self.transform.position.x - (self.laser_long_half * CS.invoke(Sincos,"Dcos",self.sudufangxiang))),(self.transform.position.y - (self.laser_long_half * CS.invoke(Sincos,"Dsin",self.sudufangxiang))),CS.f(0)))
if (self.aa > 0) then
self.aa=self.aa-1
end
for _,item in CS.each(Sincos.enemy) do
local __break1,__continue1=false,false
repeat
self.bm=CS.invoke(item,"GetComponent","Enemymove")
if ((CS.invoke(Sincos,"DistanceLine",self.dingdian_a,self.dingdian_b,CS.new("Vector2",item.position.x,item.position.y)) < (self.bm.sdbj + self.damage_r)) and (not self.bm.panding_off)) then
if ((self.bm.wudi_time <= 0) and (not self.bm.zidanwudi)) then
self.bm.life=(self.bm.life - self.damage)
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
self.damage_chengfa=self.damage_chengfa+1
if (self.aa == 0) then
local num=(item.position.y - CS.invoke(Mathf,"Pow",(CS.invoke(Mathf,"Pow",(self.bm.sdbj + self.damage_r),CS.f(2)) - CS.invoke(Mathf,"Pow",CS.invoke(Mathf,"Abs",(self.transform.position.x - item.position.x)),CS.f(2))),CS.f(0.5)))
if (num < (self.transform.position.y - CS.f(4.9))) then
num=CS.f((self.transform.position.y - CS.f(4.9)))
end
if (Sincos.effect_cut < 2) then
CS.invoke(Object,"Instantiate",self.laser_deathA,CS.new("Vector3",self.transform.position.x,num,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.invoke(UnityEngine.Random,"Range",0,360))).transform.parent=self.transform
end
end
end
self.color_blue=5
end
until true
if __break1 then break end
end
for _,item2 in CS.each(Sincos.boss) do
local __break2,__continue2=false,false
repeat
self.bm2=CS.invoke(item2,"GetComponent","Bossmove")
if (CS.invoke(Sincos,"DistanceLine",self.dingdian_a,self.dingdian_b,CS.new("Vector2",item2.transform.position.x,item2.transform.position.y)) < (self.bm2.sdbj + self.damage_r)) then
if ((self.bm2.wudi_time <= 0) and (not self.bm2.zidanwudi)) then
self.bm2.life=(self.bm2.life - self.damage)
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
if ((self.bm2.life < 1200) and self.bm2.xuruo) then
Sincos.se_enemy_hurt_count=Sincos.se_enemy_hurt_count+1
end
self.damage_chengfa=self.damage_chengfa+1
if (self.aa == 0) then
local num2=(item2.transform.position.y - CS.invoke(Mathf,"Pow",(CS.invoke(Mathf,"Pow",(self.bm2.sdbj + self.damage_r),CS.f(2)) - CS.invoke(Mathf,"Pow",CS.invoke(Mathf,"Abs",(self.transform.position.x - item2.transform.position.x)),CS.f(2))),CS.f(0.5)))
if (num2 < (self.transform.position.y - CS.f(4.9))) then
num2=CS.f((self.transform.position.y - CS.f(4.9)))
end
if (Sincos.effect_cut < 2) then
CS.invoke(Object,"Instantiate",self.laser_deathA,CS.new("Vector3",self.transform.position.x,num2,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.invoke(UnityEngine.Random,"Range",0,360))).transform.parent=self.transform
end
end
end
self.color_blue=5
end
until true
if __break2 then break end
end
if (self.color_blue > 0) then
self.color_blue=self.color_blue-1
end
end
end
function Damage7_5.defaults(self)
self.damage=0
self.damage_r=0
self.laser_long_half=0
self.bm=nil
self.bm2=nil
self.a=0
self.aa=0
self.dingdian_a=CS.Vector2()
self.dingdian_b=CS.Vector2()
self.color_blue=0
self.sudufangxiang=0
self.laser_deathA=nil
self.damage_chengfa=0
end
-- Damage7_8.cs SHA256 8268105c6f0811df8a8c7cedb1dd8552374e22600b2a36f2e55884bc12d86dc3
Damage7_8={__get={},__set={}}
Damage7_8.__index=function(o,k) local getter=Damage7_8.__get[k];if getter then return getter(o) end;return Damage7_8[k] end
Damage7_8.__newindex=function(o,k,v) local setter=Damage7_8.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Damage7_8.__base="MonoBehaviour"
function Damage7_8:FixedUpdate()

if (self.a > 0) then
self.a=self.a-1
do return  end
end
self.a=3
if (self.damage > 0) then
self.sudufangxiang=CS.f(self.transform.rotation.eulerAngles.z)
self.dingdian_a=CS.copy(CS.new("Vector3",self.transform.position.x,self.transform.position.y,CS.f(0)))
self.dingdian_b=CS.copy(CS.new("Vector3",(self.transform.position.x + ((self.laser_long_half * CS.invoke(Sincos,"Dcos",self.sudufangxiang)) * self.transform.localScale.x)),(self.transform.position.y + ((self.laser_long_half * CS.invoke(Sincos,"Dsin",self.sudufangxiang)) * self.transform.localScale.x)),CS.f(0)))
for _,item in CS.each(Sincos.enemy) do
local __break1,__continue1=false,false
repeat
self.bm=CS.invoke(item,"GetComponent","Enemymove")
if ((CS.invoke(Sincos,"DistanceLine",self.dingdian_a,self.dingdian_b,CS.new("Vector2",item.position.x,item.position.y)) < (self.bm.sdbj + (self.damage_r * self.transform.localScale.y))) and (not self.bm.panding_off)) then
if ((self.bm.wudi_time <= 0) and (not self.bm.zidanwudi)) then
self.bm.life=(self.bm.life - self.damage)
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
end
if (self.aa > 0) then
self.aa=self.aa-1
else
self.aa=2
local vector=CS.copy(CS.Vector2())
if (CS.invoke(Sincos,"Distance",self.transform,item) < (self.bm.sdbj + (self.damage_r * self.transform.localScale.y))) then
vector=CS.copy(self.transform.position)
else
local p=CS.copy(CS.invoke(Sincos,"Point_to_line_Chuidianzuobiao",CS.new("Vector2",item.position.x,item.position.y),self.dingdian_a,self.dingdian_b))
local num=CS.invoke(Mathf,"Pow",(CS.invoke(Mathf,"Pow",(self.bm.sdbj + (self.damage_r * self.transform.localScale.y)),CS.f(2)) - CS.invoke(Mathf,"Pow",CS.invoke(Sincos,"Distance",p,CS.new("Vector2",item.position.x,item.position.y)),CS.f(2))),CS.f(0.5))
vector=CS.copy((p - CS.new("Vector2",(num * CS.invoke(Sincos,"Dcos",self.sudufangxiang)),(num * CS.invoke(Sincos,"Dsin",self.sudufangxiang)))))
end
if (Sincos.effect_cut < 2) then
CS.invoke(Object,"Instantiate",self.laser_deathA,CS.new("Vector3",(vector.x + CS.invoke(UnityEngine.Random,"Range",(-CS.f(0.15)),CS.f(0.15))),(vector.y + CS.invoke(UnityEngine.Random,"Range",(-CS.f(0.15)),CS.f(0.15))),CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.invoke(UnityEngine.Random,"Range",0,360)))
end
end
end
until true
if __break1 then break end
end
for _,item2 in CS.each(Sincos.boss) do
local __break2,__continue2=false,false
repeat
self.bm2=CS.invoke(item2,"GetComponent","Bossmove")
if (CS.invoke(Sincos,"DistanceLine",self.dingdian_a,self.dingdian_b,CS.new("Vector2",item2.transform.position.x,item2.transform.position.y)) < (self.bm2.sdbj + (self.damage_r * self.transform.localScale.y))) then
if ((item2.transform.position.y - CS.invoke(Mathf,"Pow",(CS.invoke(Mathf,"Pow",(self.bm2.sdbj + (self.damage_r * self.transform.localScale.y)),CS.f(2)) - CS.invoke(Mathf,"Pow",CS.invoke(Mathf,"Abs",(self.transform.position.x - item2.transform.position.x)),CS.f(2))),CS.f(0.5))) < (self.transform.position.y - CS.f(4.9))) then
local position=CS.copy(self.transform.position)
end
if (((self.bm2.wudi_time <= 0) and (not self.bm2.zidanwudi)) and (Sincos.dam7_8_chengfa <= self.chengfa_num)) then
self.bm2.life=(self.bm2.life - self.damage)
Sincos.dam7_8_chengfa=(Sincos.dam7_8_chengfa + self.damage)
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
if ((self.bm2.life < 1200) and self.bm2.xuruo) then
Sincos.se_enemy_hurt_count=Sincos.se_enemy_hurt_count+1
end
end
if (self.aa > 0) then
self.aa=self.aa-1
else
self.aa=1
local vector2=CS.copy(CS.Vector2())
if (CS.invoke(Sincos,"Distance",self.transform,item2.transform) < (self.bm2.sdbj + (self.damage_r * self.transform.localScale.y))) then
vector2=CS.copy(self.transform.position)
else
local p2=CS.copy(CS.invoke(Sincos,"Point_to_line_Chuidianzuobiao",CS.new("Vector2",item2.transform.position.x,item2.transform.position.y),self.dingdian_a,self.dingdian_b))
local num2=CS.invoke(Mathf,"Pow",(CS.invoke(Mathf,"Pow",(self.bm2.sdbj + (self.damage_r * self.transform.localScale.y)),CS.f(2)) - CS.invoke(Mathf,"Pow",CS.invoke(Sincos,"Distance",p2,CS.new("Vector2",item2.transform.position.x,item2.transform.position.y)),CS.f(2))),CS.f(0.5))
vector2=CS.copy((p2 - CS.new("Vector2",(num2 * CS.invoke(Sincos,"Dcos",self.sudufangxiang)),(num2 * CS.invoke(Sincos,"Dsin",self.sudufangxiang)))))
end
if (Sincos.effect_cut < 2) then
CS.invoke(Object,"Instantiate",self.laser_deathA,CS.new("Vector3",(vector2.x + CS.invoke(UnityEngine.Random,"Range",(-CS.f(0.15)),CS.f(0.15))),(vector2.y + CS.invoke(UnityEngine.Random,"Range",(-CS.f(0.15)),CS.f(0.15))),CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.invoke(UnityEngine.Random,"Range",0,360)))
end
end
end
until true
if __break2 then break end
end
end
end
function Damage7_8.defaults(self)
self.damage=0
self.damage_r=0
self.laser_long_half=0
self.chengfa_num=0
self.bm=nil
self.bm2=nil
self.a=0
self.aa=0
self.dingdian_a=CS.Vector2()
self.dingdian_b=CS.Vector2()
self.sudufangxiang=0
self.laser_deathA=nil
end
-- Damage7_9.cs SHA256 c8428754cd976ed721e1b41173dc7e62c43304d8f2d749a3d74536a886e91aec
Damage7_9={__get={},__set={}}
Damage7_9.__index=function(o,k) local getter=Damage7_9.__get[k];if getter then return getter(o) end;return Damage7_9[k] end
Damage7_9.__newindex=function(o,k,v) local setter=Damage7_9.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Damage7_9.__base="MonoBehaviour"
function Damage7_9:Start()

self.sudufangxiang=CS.f(self.transform.rotation.eulerAngles.z)
self.dingdian_a=CS.copy(CS.new("Vector3",(self.transform.position.x + (self.chang * CS.invoke(Sincos,"Dcos",self.sudufangxiang))),(self.transform.position.y + (self.chang * CS.invoke(Sincos,"Dsin",self.sudufangxiang))),CS.f(0)))
self.dingdian_b=CS.copy(CS.new("Vector3",(self.transform.position.x - (self.chang * CS.invoke(Sincos,"Dcos",self.sudufangxiang))),(self.transform.position.y - (self.chang * CS.invoke(Sincos,"Dsin",self.sudufangxiang))),CS.f(0)))
end
function Damage7_9:FixedUpdate()

if (self.time_max < 0) then
do return  end
end
self.time_max=self.time_max-1
if (self.a > 0) then
self.a=self.a-1
do return  end
end
self.a=self.damage_jiange
if (self.damage > 0) then
for _,item in CS.each(Sincos.enemy) do
local __break1,__continue1=false,false
repeat
self.bm=CS.invoke(item,"GetComponent","Enemymove")
if (((((CS.invoke(Sincos,"DistanceLine",self.dingdian_a,self.dingdian_b,CS.new("Vector2",item.position.x,item.position.y)) < (self.bm.sdbj + self.kuan)) and (not self.bm.panding_off)) and (self.bm.wudi_time <= 0)) and (not self.bm.zidanwudi)) and (Sincos.dam6_chengfa <= self.chengfa_num)) then
Sincos.dam6_chengfa=Sincos.dam6_chengfa+1
self.bm.life=(self.bm.life - self.damage)
local flag=false
do
local i=0
while (i < self.list.emy.Count) do
local __break2,__continue2=false,false
repeat
if (self.bm == self.list.emy[i]) then
flag=true
end
until true
if __break2 then break end
i=i+1
end
end
if (not flag) then
CS.invoke(self.list.emy,"Add",self.bm)
end
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
self.color_blue=10
end
until true
if __break1 then break end
end
for _,item2 in CS.each(Sincos.boss) do
local __break3,__continue3=false,false
repeat
self.bm2=CS.invoke(item2,"GetComponent","Bossmove")
if ((((CS.invoke(Sincos,"DistanceLine",self.dingdian_a,self.dingdian_b,CS.new("Vector2",item2.transform.position.x,item2.transform.position.y)) < (self.bm2.sdbj + self.kuan)) and (self.bm2.wudi_time <= 0)) and (not self.bm2.zidanwudi)) and (Sincos.dam6_chengfa <= self.chengfa_num)) then
Sincos.dam6_chengfa=Sincos.dam6_chengfa+1
self.bm2.life=(self.bm2.life - self.damage)
local flag2=false
do
local j=0
while (j < self.list.bos.Count) do
local __break4,__continue4=false,false
repeat
if (self.bm2 == self.list.bos[j]) then
flag2=true
end
until true
if __break4 then break end
j=j+1
end
end
if (not flag2) then
CS.invoke(self.list.bos,"Add",self.bm2)
end
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
if ((self.bm2.life < 1200) and self.bm2.xuruo) then
Sincos.se_enemy_hurt_count=Sincos.se_enemy_hurt_count+1
end
self.color_blue=10
end
until true
if __break3 then break end
end
if (self.color_blue > 0) then
self.color_blue=self.color_blue-1
end
end
end
function Damage7_9.defaults(self)
self.damage=0
self.chang=0
self.kuan=0
self.dingdian_a=CS.Vector2()
self.dingdian_b=CS.Vector2()
self.sudufangxiang=0
self.chengfa_num=0
self.bm=nil
self.bm2=nil
self.damage_jiange=0
self.a=0
self.color_blue=0
self.list=nil
self.time_max=0
end
-- Damage_beilv.cs SHA256 78d0af91c860b8a19e3224732ca081cb48d4dad53d1a56b72eda7a89d0ef17ca
Damage_beilv={__get={},__set={}}
Damage_beilv.__index=function(o,k) local getter=Damage_beilv.__get[k];if getter then return getter(o) end;return Damage_beilv[k] end
Damage_beilv.__newindex=function(o,k,v) local setter=Damage_beilv.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Damage_beilv.__base="MonoBehaviour"
function Damage_beilv:Start()

self.dm1=CS.invoke(self,"GetComponent","Damage1")
self.sr=CS.invoke(self,"GetComponent","SpriteRenderer")
if Sincos.if_change then
self.beilv=CS.f(((Sincos.suipian_beilv_hong - CS.f(1)) + CS.f(1)))
else
self.beilv=CS.f(((Sincos.suipian_beilv_zi - CS.f(1)) + CS.f(1)))
end
if (self.beilv > CS.f(1)) then
self.sr.sprite=self.bullet_light
self.sr.color=CS.new("Color",CS.f(1),CS.f(1),CS.f(1),CS.f(1))
end
self.dm1.damage=CS.trunc(((CS.f(self.dm1.damage) * self.beilv)))
end
function Damage_beilv.defaults(self)
self.dm1=nil
self.beilv=0
self.bullet_light=nil
self.sr=nil
end
-- Damage_zhuqiang.cs SHA256 80e20a8f00e1f029a8916311a6baa5f1289e0f3a6ac5c1b8c743a558af6b827e
Damage_zhuqiang={__get={},__set={}}
Damage_zhuqiang.__index=function(o,k) local getter=Damage_zhuqiang.__get[k];if getter then return getter(o) end;return Damage_zhuqiang[k] end
Damage_zhuqiang.__newindex=function(o,k,v) local setter=Damage_zhuqiang.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Damage_zhuqiang.__base="MonoBehaviour"
function Damage_zhuqiang:FixedUpdate()

local flag=false
CS.invoke(self.transform,"Translate",CS.f(0),self.speed,CS.f(0))
if (self.transform.position.y > CS.f(1)) then
CS.invoke(Sincos,"Delete_zhuqiang",self.order)
do return  end
end
do
local num=(Sincos.enemy.Count - 1)
while (num >= 0) do
local __break1,__continue1=false,false
repeat
self.bm=CS.invoke(Sincos.enemy[num],"GetComponent","Enemymove")
if ((((((Sincos.enemy[num].position.x - self.transform.position.x)) * ((Sincos.enemy[num].position.x - self.transform.position.x))) + (((Sincos.enemy[num].position.y - self.transform.position.y)) * ((Sincos.enemy[num].position.y - self.transform.position.y)))) < (((self.damage_r + self.bm.sdbj)) * ((self.damage_r + self.bm.sdbj)))) and (not self.bm.panding_off)) then
if ((self.bm.wudi_time <= 0) and (not self.bm.zidanwudi)) then
self.bm.life=(self.bm.life - self.damage)
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
Sincos.zhuqiang_aim=self.bm.transform
Sincos.jiejiefanghu_val=(Sincos.jiejiefanghu_val + 50)
if (Sincos.jiejiefanghu_val > 299999) then
Sincos.jiejiefanghu_val=299999
end
end
if (Sincos.effect_cut < 2) then
CS.invoke(Object,"Instantiate",self.zhuqiang_death,self.transform.position,self.transform.rotation)
end
CS.invoke(Sincos,"Delete_zhuqiang",self.order)
flag=true
__break1=true;break
end
until true
if __break1 then break end
num=num-1
end
end
if flag then
do return  end
end
local num2=(Sincos.boss.Count - 1)
while true do
local __break2,__continue2=false,false
repeat
if (num2 >= 0) then
self.bm2=CS.invoke(Sincos.boss[num2],"GetComponent","Bossmove")
if (((((Sincos.boss[num2].transform.position.x - self.transform.position.x)) * ((Sincos.boss[num2].transform.position.x - self.transform.position.x))) + (((Sincos.boss[num2].transform.position.y - self.transform.position.y)) * ((Sincos.boss[num2].transform.position.y - self.transform.position.y)))) < (((self.damage_r + self.bm2.sdbj)) * ((self.damage_r + self.bm2.sdbj)))) then
__break2=true;break
end
num2=num2-1
__continue2=true;break
end
do return  end
until true
if __break2 then break end
end
if ((self.bm2.wudi_time <= 0) and (not self.bm2.zidanwudi)) then
self.bm2.life=(self.bm2.life - self.damage)
Sincos.fenshu_now=(Sincos.fenshu_now + 10)
Sincos.zhuqiang_aim=self.bm2.transform
Sincos.jiejiefanghu_val=(Sincos.jiejiefanghu_val + 50)
if (Sincos.jiejiefanghu_val > 299999) then
Sincos.jiejiefanghu_val=299999
end
if self.chongneng_add then
if ((not Sincos.if_change) and (not Sincos.kaiguan_a)) then
if (Sincos.suipian_beilv_hong < CS.f(3)) then
Sincos.suipian_beilv_hong=(Sincos.suipian_beilv_hong + CS.f(0.0012))
else
Sincos.suipian_beilv_hong=CS.f(3)
end
end
if (Sincos.if_change and (not Sincos.kaiguan_b)) then
if (Sincos.suipian_beilv_zi < CS.f(3)) then
Sincos.suipian_beilv_zi=(Sincos.suipian_beilv_zi + CS.f(0.0012))
else
Sincos.suipian_beilv_zi=CS.f(3)
end
end
end
if ((self.bm2.life < 1200) and self.bm2.xuruo) then
Sincos.se_enemy_hurt_count=Sincos.se_enemy_hurt_count+1
end
end
if (Sincos.effect_cut < 2) then
CS.invoke(Object,"Instantiate",self.zhuqiang_death,self.transform.position,self.transform.rotation)
end
CS.invoke(Sincos,"Delete_zhuqiang",self.order)
end
function Damage_zhuqiang.defaults(self)
self.order=0
self.damage=0
self.damage_r=0
self.speed=0
self.bm=nil
self.bm2=nil
self.zhuqiang_death=nil
self.chongneng_add=false
end
-- Jiejie_huiliu.cs SHA256 7bdcfd4e02ee234dfa66f2632f09333d97f1cf964e16d0799a32060a94eab649
Jiejie_huiliu={__get={},__set={}}
Jiejie_huiliu.__index=function(o,k) local getter=Jiejie_huiliu.__get[k];if getter then return getter(o) end;return Jiejie_huiliu[k] end
Jiejie_huiliu.__newindex=function(o,k,v) local setter=Jiejie_huiliu.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Jiejie_huiliu.__base="MonoBehaviour"
function Jiejie_huiliu:Start()

self.sr=CS.invoke(CS.invoke(self.transform,"GetChild",0),"GetComponent","SpriteRenderer")
self.au=CS.invoke(self,"GetComponent","AudioSource")
self.par=CS.invoke(self,"GetComponent","ParticleSystem")
self.huiliu_pre=CS.f((CS.f(10) / CS.f(self.huiliu_time_chixu)))
self.tf=CS.invoke(self.transform,"GetChild",0).transform
Sincos.huiliu_time_max=self.huiliu_time_max
Sincos.huiliu_time_max_max=self.huiliu_time_max
end
function Jiejie_huiliu:FixedUpdate()

if ((not Sincos.ifduihua) and (not Sincos.iffuka)) then
Sincos.huiliu_time_max=Sincos.huiliu_time_max-1
end
Sincos.zidonghuishou=true
if (((Sincos.huiliu_time_max == 0) and self.b) and (not Sincos.xiaodan_huishou.xiaodan)) then
Sincos.xiaodan_huishou.xiaodan=true
Sincos.hyper_system_ready=false
Sincos.if_liankai=false
Sincos.liankai_count=0
Sincos.liankai_beilv=10
end
self.transform.position=CS.copy(CS.new("Vector3",Sincos.zijix,Sincos.zijiy,CS.f(0)))
Sincos.xiaodan_huishou.x=Sincos.zijix
Sincos.xiaodan_huishou.y=Sincos.zijiy
if Sincos.xiaodan_huishou.xiaodan then
if self.b then
if self.a then
Sincos.if_now_huiliu=true
self.a=false
CS.invoke(self.au,"Play")
CS.invoke(self.par,"Play")
Sincos.xiaodan_huishou.r=CS.f(10)
Sincos.xiaodan_huiliu_bug=true
Sincos.bonuns=false
if (Sincos.jiejie_cengshu_beforhuiliu == 3) then
Sincos.if_liankai=true
Sincos.liankai_count=Sincos.liankai_count+1
Sincos.liankai_beilv=Sincos.liankai_beilv+1
if ((Sincos.steam_2liankai_now and (Sincos.liankai_beilv >= 20)) and (((Sincos.select_nandu == 2) or (Sincos.select_nandu == 3)))) then
CS.invoke(SteamStatsAndAchievements,"SetAchi",THASL_Achi.THASL_10BorderInStage2)
Sincos.steam_2liankai_now=false
end
else
Sincos.if_liankai=false
Sincos.liankai_count=0
Sincos.liankai_beilv=10
end
end
Sincos.xiaodan_huishou.r=(Sincos.xiaodan_huishou.r - self.huiliu_pre)
self.tf.localScale=CS.copy(CS.new("Vector3",(Sincos.xiaodan_huishou.r * CS.f(0.25)),(Sincos.xiaodan_huishou.r * CS.f(0.25)),CS.f(1)))
self.sr.color=(self.sr.color + CS.new("Color",CS.f(0),CS.f(0),CS.f(0),CS.f(0.01)))
if (self.huiliu_time_chixu == 0) then
Sincos.xiaodan_huishou.xiaodan=false
Sincos.xiaodan_huiliu_bug=false
self.b=false
end
end
self.huiliu_time_chixu=self.huiliu_time_chixu-1
end
if (not self.b) then
if (self.huiliu_time_chixu == (-30)) then
local item=CS.new("Sincos.Xiaodan_im")
item.position=CS.copy(CS.new("Vector3",Sincos.zijix,Sincos.zijiy,CS.f(0)))
item.r=CS.f(0.5)
item.time=30
item.index=100
item.no_daoju=false
CS.invoke(Sincos.xiaodan3,"Add",item)
Sincos.jiejie_cengshu_beforhuiliu=0
Sincos.jiejie_weichi=false
Sincos.if_now_huiliu=false
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
self.huiliu_time_chixu=self.huiliu_time_chixu-1
end
end
function Jiejie_huiliu.defaults(self)
self.huiliu_time_max=0
self.huiliu_time_chixu=0
self.a=true
self.b=true
self.time=0
self.huiliu_pre=0
self.sr=nil
self.au=nil
self.par=nil
self.tf=nil
end
-- Jitifashezidan.cs SHA256 5a28c694c394a1425dcbf224e1c2f11fa0ba8ef70073a5332d6537185225d439
Jitifashezidan={__get={},__set={}}
Jitifashezidan.__index=function(o,k) local getter=Jitifashezidan.__get[k];if getter then return getter(o) end;return Jitifashezidan[k] end
Jitifashezidan.__newindex=function(o,k,v) local setter=Jitifashezidan.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Jitifashezidan.__base="MonoBehaviour"
function Jitifashezidan:Start()

self.fasheti=self.fasheti_gaosu
self.zhouqi=self.zhouqi_gaosu
self.chaoxiang=CS.f(self.chaoxiang_gaosu)
self.time=self.time_start_yanchi
end
function Jitifashezidan:FixedUpdate()

if ((not self.baozou_open) or (Sincos.hyper_time == 0)) then
self.fasheti=self.fasheti_gaosu
self.zhouqi=self.zhouqi_gaosu
self.chaoxiang=CS.f(self.chaoxiang_gaosu)
if Sincos.anjian_now[4] then
self.fasheti=self.fasheti_disu
self.zhouqi=self.zhouqi_disu
self.chaoxiang=CS.f(self.chaoxiang_disu)
end
else
self.fasheti=self.baozou_gaosu
self.zhouqi=self.baozou_zhouqi_gaosu
self.chaoxiang=CS.f(self.chaoxiang_gaosu)
if Sincos.anjian_now[4] then
self.fasheti=self.baozou_disu
self.zhouqi=self.baozou_zhouqi_disu
self.chaoxiang=CS.f(self.chaoxiang_disu)
end
end
if (Sincos.anjian_now[5] and (not Sincos.ifduihua)) then
if (self.time > 0) then
self.time=self.time-1
else
if ((CS.rem(((Sincos.gametime + self.zhouqi_pianyi)),self.zhouqi) == 0) and (self.fasheti ~= nil)) then
CS.invoke(Object,"Instantiate",self.fasheti,self.transform.position,CS.invoke(Quaternion,"Euler",self.transform.rotation.x,self.transform.rotation.y,self.chaoxiang))
end
end
else
if (self.time < self.time_start_yanchi) then
self.time=(self.time + 3)
end
end
end
function Jitifashezidan.defaults(self)
self.fasheti=nil
self.fasheti_gaosu=nil
self.fasheti_disu=nil
self.zhouqi=0
self.zhouqi_gaosu=0
self.zhouqi_disu=0
self.chaoxiang=0
self.chaoxiang_gaosu=0
self.chaoxiang_disu=0
self.baozou_open=false
self.baozou_gaosu=nil
self.baozou_disu=nil
self.baozou_zhouqi_gaosu=0
self.baozou_zhouqi_disu=0
self.zhouqi_pianyi=0
self.time_start_yanchi=0
self.time=0
end
-- Jitifashezidan_xuli.cs SHA256 c3cf067932b9fe311526e7b278131d17d618b685b792d778160b8d3ddace6170
Jitifashezidan_xuli={__get={},__set={}}
Jitifashezidan_xuli.__index=function(o,k) local getter=Jitifashezidan_xuli.__get[k];if getter then return getter(o) end;return Jitifashezidan_xuli[k] end
Jitifashezidan_xuli.__newindex=function(o,k,v) local setter=Jitifashezidan_xuli.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Jitifashezidan_xuli.__base="MonoBehaviour"
function Jitifashezidan_xuli:Start()

self.au=CS.invoke(self,"GetComponent","AudioSource")
end
function Jitifashezidan_xuli:FixedUpdate()

if (not Sincos.ifduihua) then
if Sincos.anjian_now[5] then
if (not self.tiandao) then
self.time_xuli=CS.f((self.time_xuli + CS.f(1)))
else
if Sincos.if_change then
self.time_xuli=CS.f((self.time_xuli + ((((Sincos.suipian_beilv_hong - CS.f(1))) / CS.f(2)) + CS.f(1))))
else
self.time_xuli=CS.f((self.time_xuli + ((((Sincos.suipian_beilv_zi - CS.f(1))) / CS.f(2)) + CS.f(1))))
end
end
if (self.time_xuli >= CS.f(163)) then
Sincos.jiejiefanghu_val=(Sincos.jiejiefanghu_val + 50)
if (Sincos.jiejiefanghu_val > 299999) then
Sincos.jiejiefanghu_val=299999
end
end
if (not self.a) then
self.a=true
CS.invoke(self.au,"Play")
end
if ((not Sincos.anjian_now[4]) and self.key) then
Jitifashezidan_xuli.Fashe(self)
end
else
self.time_xuli=CS.f(CS.f(0))
self.a=false
CS.invoke(self.au,"Stop")
end
else
self.time_xuli=CS.f(CS.f(0))
self.a=false
CS.invoke(self.au,"Stop")
end
if Sincos.anjian_now[4] then
self.key=true
else
self.key=false
end
end
function Jitifashezidan_xuli:Fashe()

if (self.time_xuli >= CS.f(163)) then
CS.invoke(Object,"Instantiate",self.fasheti4,self.transform.position,CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(0)))
self.time_xuli=CS.f(CS.f(0))
end
if (self.time_xuli >= CS.f(123)) then
CS.invoke(Object,"Instantiate",self.fasheti3,self.transform.position,CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(0)))
self.time_xuli=CS.f(CS.f(0))
end
if (self.time_xuli >= CS.f(83)) then
CS.invoke(Object,"Instantiate",self.fasheti2,self.transform.position,CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(0)))
self.time_xuli=CS.f(CS.f(0))
end
if (self.time_xuli >= CS.f(45)) then
CS.invoke(Object,"Instantiate",self.fasheti1,self.transform.position,CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(0)))
self.time_xuli=CS.f(CS.f(0))
end
self.time_xuli=CS.f(CS.f(0))
self.a=false
CS.invoke(self.au,"Stop")
end
function Jitifashezidan_xuli.defaults(self)
self.fasheti1=nil
self.fasheti2=nil
self.fasheti3=nil
self.fasheti4=nil
self.time_xuli=0
self.tiandao=false
self.a=false
self.key=false
self.au=nil
end
-- Lan_ins_kongzhi.cs SHA256 a8108af77a1b4e8d22858133f00cd9f8429c9253e99e1eccc4232d1deed2356e
Lan_ins_kongzhi={__get={},__set={}}
Lan_ins_kongzhi.__index=function(o,k) local getter=Lan_ins_kongzhi.__get[k];if getter then return getter(o) end;return Lan_ins_kongzhi[k] end
Lan_ins_kongzhi.__newindex=function(o,k,v) local setter=Lan_ins_kongzhi.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Lan_ins_kongzhi.__base="MonoBehaviour"
function Lan_ins_kongzhi:Start()

self.time=CS.trunc(((((CS.f(3) - Sincos.suipian_beilv_hong)) * CS.f(90))))
CS.invoke(self,"GetComponent","Tongyong_death").time=(self.time + 1)
Sincos.bayunlan_ins=self
self.move=CS.invoke(self,"GetComponent","Bulletmove_xuanzhuan")
self.xuanzhuan=CS.invoke(self,"GetComponent","Tongyong_xuanzhuan")
end
function Lan_ins_kongzhi:FixedUpdate()

if (self.move.speed > CS.f(0.0005)) then
self.move.speed=CS.f((self.move.speed - CS.f(0.0005)))
end
if (self.xuanzhuan.zhuansu < (-CS.f(0.1))) then
self.xuanzhuan.zhuansu=CS.f((self.xuanzhuan.zhuansu + CS.f(0.1)))
end
if (self.time == 0) then
if (Sincos.bayunlan == nil) then
CS.invoke(Object,"Instantiate",self.lan_ins,self.transform.position,self.transform.rotation)
end
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
self.time=self.time-1
end
function Lan_ins_kongzhi.defaults(self)
self.move=nil
self.xuanzhuan=nil
self.lan_ins=nil
self.time=60
end
-- Lan_kongzhi.cs SHA256 ec9021b46981d45b8e9d425993dde27acaa25ea76eedee9ff519bbd16f3866c0
Lan_kongzhi={__get={},__set={}}
Lan_kongzhi.__index=function(o,k) local getter=Lan_kongzhi.__get[k];if getter then return getter(o) end;return Lan_kongzhi[k] end
Lan_kongzhi.__newindex=function(o,k,v) local setter=Lan_kongzhi.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Lan_kongzhi.__base="MonoBehaviour"
function Lan_kongzhi:Start()

self.dam=CS.invoke(self,"GetComponent","Damage5_5")
self.lan1=CS.invoke(self.transform,"Find","lan1")
self.lan2=CS.invoke(self.transform,"Find","lan2")
Sincos.if_bayunlan=1
Sincos.bayunlan=self
self.dis=CS.f(CS.f(100000))
self.ps=CS.invoke(self,"GetComponent","ParticleSystem")
self.au=CS.invoke(self,"GetComponent","AudioSource")
if (Sincos.enemy ~= nil) then
for _,item in CS.each(Sincos.enemy) do
local __break1,__continue1=false,false
repeat
self.dis0=CS.f(CS.invoke(Sincos,"Distance",item,self.transform))
if ((self.dis0 < self.dis) and (CS.invoke(item,"GetComponent","Enemymove").wudi_time <= 0)) then
self.dis=CS.f(self.dis0)
self.obj=item
end
until true
if __break1 then break end
end
end
if (Sincos.boss ~= nil) then
for _,item2 in CS.each(Sincos.boss) do
local __break2,__continue2=false,false
repeat
self.dis0=CS.f(CS.invoke(Sincos,"Distance",item2.transform,self.transform))
if (self.dis0 < self.dis) then
self.dis=CS.f(self.dis0)
self.obj=item2.transform
end
until true
if __break2 then break end
end
end
if ((self.obj ~= nil) and (((((self.obj.position.x < CS.f(0)) or (self.obj.position.x > CS.f(9))) or (self.obj.position.y > CS.f(0))) or (self.obj.position.y < (-CS.f(10)))))) then
self.obj=nil
end
end
function Lan_kongzhi:FixedUpdate()

if (Sincos.anjian_now[5] and (not Sincos.ifduihua)) then
self.dam.damage=self.damage
if (self.suofang <= CS.f(0.96)) then
self.suofang=CS.f((self.suofang + CS.f(0.04)))
end
else
self.dam.damage=0
if (self.suofang >= CS.f(0.04)) then
self.suofang=CS.f((self.suofang - CS.f(0.04)))
end
end
self.lan1.transform.localScale=CS.copy(CS.new("Vector3",(CS.f(1.2) * self.suofang),(CS.f(1.2) * self.suofang),CS.f(1)))
self.lan2.transform.localScale=CS.copy(CS.new("Vector3",self.suofang,self.suofang,CS.f(1)))
if ((((self.transform.position.x < CS.f(0)) or (self.transform.position.x > CS.f(9))) or (self.transform.position.y > CS.f(3))) or (self.transform.position.y < (-CS.f(10)))) then
self.obj=nil
self.transform.position=CS.copy((self.transform.position + (((CS.new("Vector3",Sincos.zijix,Sincos.zijiy,CS.f(0)) - CS.new("Vector3",self.transform.position.x,self.transform.position.y,CS.f(0)))) / CS.f(15))))
end
if (not self.ready_death) then
if (Sincos.anjian_now[4] or (self.maxtime > 0)) then
if Sincos.anjian_now[4] then
self.maxtime=60
else
self.maxtime=self.maxtime-1
end
if (self.obj ~= nil) then
if ((((self.obj.position.x < CS.f(0)) or (self.obj.position.x > CS.f(9))) or (self.obj.position.y > CS.f(0))) or (self.obj.position.y < (-CS.f(10)))) then
self.obj=nil
else
local num=(CS.invoke(Sincos,"Distance",self.transform,self.obj) - CS.f(1.15))
if (num > CS.f(0.1)) then
num=CS.f(CS.f(0.1))
end
if (num < (-CS.f(0.1))) then
num=CS.f((-CS.f(0.1)))
end
local num2=(self.obj.position.y - self.transform.position.y)
local num3=(self.obj.position.x - self.transform.position.x)
if (num3 == CS.f(0)) then
num3=CS.f(CS.f(1E-05))
end
local num4=CS.invoke(Mathf,"Atan",(num2 / num3))
if (self.obj.position.x < self.transform.position.x) then
num4=CS.f((num4 + MathF.PI))
end
self.transform.position=CS.copy((self.transform.position + CS.new("Vector3",(num * CS.invoke(Mathf,"Cos",num4)),(num * CS.invoke(Mathf,"Sin",num4)),CS.f(0))))
end
else
self.dis=CS.f(CS.f(100000))
if (Sincos.enemy ~= nil) then
for _,item3 in CS.each(Sincos.enemy) do
local __break3,__continue3=false,false
repeat
self.dis0=CS.f(CS.invoke(Sincos,"Distance",item3,self.transform))
if ((self.dis0 < self.dis) and (CS.invoke(item3,"GetComponent","Enemymove").wudi_time <= 0)) then
self.dis=CS.f(self.dis0)
self.obj=item3
end
until true
if __break3 then break end
end
end
if (Sincos.boss ~= nil) then
for _,item4 in CS.each(Sincos.boss) do
local __break4,__continue4=false,false
repeat
self.dis0=CS.f(CS.invoke(Sincos,"Distance",item4.transform,self.transform))
if (self.dis0 < self.dis) then
self.dis=CS.f(self.dis0)
self.obj=item4.transform
end
until true
if __break4 then break end
end
end
if ((self.obj ~= nil) and (((((self.obj.position.x < CS.f(0)) or (self.obj.position.x > CS.f(9))) or (self.obj.position.y > CS.f(0))) or (self.obj.position.y < (-CS.f(10)))))) then
self.obj=nil
end
end
else
self.obj=nil
self.transform.position=CS.copy((self.transform.position + (((CS.new("Vector3",Sincos.zijix,(Sincos.zijiy + CS.f(3)),CS.f(0)) - CS.new("Vector3",self.transform.position.x,self.transform.position.y,CS.f(0)))) / CS.f(15))))
end
end
if (self.muti == nil) then
if (Sincos.if_bayunlan == 1) then
self.time=(CS.trunc(((((Sincos.suipian_beilv_zi - CS.f(1))) * CS.f(480)))) + 1)
Sincos.if_bayunlan=(-1)
end
if ((self.time == 0) and (not self.bug_fix)) then
self.bug_fix=true
CS.invoke(self.ps,"Play")
CS.invoke(self.au,"Play")
self.ready_death=true
Sincos.bayunlan=nil
local tongyong_jianxianjianyin=CS.invoke(self.gameObject,"AddComponent","Tongyong_jianxianjianyin")
tongyong_jianxianjianyin.time_long=30
tongyong_jianxianjianyin.time_yanshi=30
tongyong_jianxianjianyin.yingyongziwuti=true
local item=CS.new("Sincos.Renwu")
local action=(function() item.ac=function() CS.invoke(UnityEngine.Object,"Destroy",self.gameObject) end;return item.ac end)()
item.time=120
CS.invoke(Sincos.renwu,"Add",item)
local item2=CS.new("Sincos.Renwu")
local action2=(function() item2.ac=function() CS.invoke(UnityEngine.Object,"Destroy",CS.invoke(self,"GetComponent","Damage5_5")) end;return item2.ac end)()
item2.time=60
CS.invoke(Sincos.renwu,"Add",item2)
end
self.time=self.time-1
end
end
function Lan_kongzhi.defaults(self)
self.jiao=0
self.suofang=0
self.speed=0
self.obj=nil
self.dis=0
self.dis0=0
self.maxtime=0
self.muti=nil
self.ps=nil
self.au=nil
self.ready_death=false
self.dam=nil
self.damage=0
self.lan1=nil
self.lan2=nil
self.bug_fix=false
self.time=60
end
-- Molisha_changeA.cs SHA256 bfa89947eb866369c822ba1a48fc3c2f046eacd9f7e2969d6f45d4247db4ea52
Molisha_changeA={__get={},__set={}}
Molisha_changeA.__index=function(o,k) local getter=Molisha_changeA.__get[k];if getter then return getter(o) end;return Molisha_changeA[k] end
Molisha_changeA.__newindex=function(o,k,v) local setter=Molisha_changeA.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Molisha_changeA.__base="MonoBehaviour"
function Molisha_changeA:Start()

if ((Sincos.suipian_beilv_hong ~= CS.f(3)) or (not Sincos.anjian_now[5])) then
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
self.set=true
end
self.transform.parent=nil
self.au=CS.invoke(self,"GetComponent","AudioSource")
self.transform.rotation=CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),(CS.f(0) - Sincos.ziji_zhixiang))
Sincos.dam7_8_chengfa=0
self.a=CS.invoke(CS.invoke(Sincos.ziji_now.transform,"Find","anim"),"GetComponent","SpriteRenderer")
end
function Molisha_changeA:FixedUpdate()

if self.set then
do return  end
end
if (self.time == 70) then
CS.invoke(self.au,"Play")
end
self.time=self.time+1
if (self.time < self.wudishijian) then
Sincos.wudi=true
Sincos.wudi_fugai_repair=4
end
if (self.time == self.wudishijian) then
if (Sincos.wudi_fugai_repair == 4) then
Sincos.wudi=false
Sincos.wudi_fugai_repair=0
self.a.color=CS.new("Color",CS.f(1),CS.f(1),CS.f(1))
end
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
end
function Molisha_changeA.defaults(self)
self.au=nil
self.time=0
self.a=nil
self.wudishijian=0
self.set=false
end
-- Molisha_changeB.cs SHA256 1c80f076ca7864b742792829b4cc2f3f72639132d7a181b75da1145dc4385ee1
Molisha_changeB={__get={},__set={}}
Molisha_changeB.__index=function(o,k) local getter=Molisha_changeB.__get[k];if getter then return getter(o) end;return Molisha_changeB[k] end
Molisha_changeB.__newindex=function(o,k,v) local setter=Molisha_changeB.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Molisha_changeB.__base="MonoBehaviour"
function Molisha_changeB:Start()

if ((Sincos.suipian_beilv_zi ~= CS.f(3)) or (not Sincos.anjian_now[5])) then
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
self.set=true
end
self.a=CS.invoke(CS.invoke(Sincos.ziji_now.transform,"Find","anim"),"GetComponent","SpriteRenderer")
self.au=CS.invoke(self,"GetComponent","AudioSource")
self.transform.parent=nil
end
function Molisha_changeB:FixedUpdate()

if self.set then
do return  end
end
if (self.time == 70) then
CS.invoke(self.au,"Play")
end
if (self.time < 180) then
if (CS.rem(self.time,5) == 0) then
CS.invoke(Object,"Instantiate",self.Fire_A,self.transform.position,self.transform.rotation)
end
if (CS.rem(self.time,5) == 2) then
CS.invoke(Object,"Instantiate",self.Fire_B,self.transform.position,self.transform.rotation)
end
if (CS.rem(self.time,5) == 4) then
CS.invoke(Object,"Instantiate",self.Fire_C,self.transform.position,self.transform.rotation)
end
end
self.time=self.time+1
if (self.time < self.wudishijian) then
Sincos.wudi=true
Sincos.wudi_fugai_repair=5
end
if (self.time == self.wudishijian) then
if (Sincos.wudi_fugai_repair == 5) then
Sincos.wudi=false
Sincos.wudi_fugai_repair=0
self.a.color=CS.new("Color",CS.f(1),CS.f(1),CS.f(1))
end
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
end
function Molisha_changeB.defaults(self)
self.au=nil
self.time=0
self.a=nil
self.Fire_A=nil
self.Fire_B=nil
self.Fire_C=nil
self.wudishijian=0
self.set=false
end
-- Molisha_fire_control.cs SHA256 8aaaa074793d5f308426806e5bd0d6964761a4e02f601cd8e23857db80bcbe61
Molisha_fire_control={__get={},__set={}}
Molisha_fire_control.__index=function(o,k) local getter=Molisha_fire_control.__get[k];if getter then return getter(o) end;return Molisha_fire_control[k] end
Molisha_fire_control.__newindex=function(o,k,v) local setter=Molisha_fire_control.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Molisha_fire_control.__base="MonoBehaviour"
function Molisha_fire_control:Start()

self.fire=CS.invoke(self,"GetComponent","Bullet_xiaodan_lizi")
self.fire.sudufangxiang=CS.f((self.fire.sudufangxiang + CS.invoke(Sincos,"Seedrandom",(CS.f(0) - self.sudufangxiang_add_range),self.sudufangxiang_add_range)))
self.fire.speed=CS.f((self.fire.speed + CS.invoke(Sincos,"Seedrandom",(CS.f(0) - self.speed_add_range),self.speed_add_range)))
end
function Molisha_fire_control:FixedUpdate()

CS.invoke(UnityEngine.Object,"Destroy",self)
end
function Molisha_fire_control.defaults(self)
self.fire=nil
self.sudufangxiang_add_range=0
self.speed_add_range=0
end
-- Molisha_laser.cs SHA256 c33380605e6e8d88cd2f94272483ff0f69b66a9bf7bb4c2dadc1b76937c75210
Molisha_laser={__get={},__set={}}
Molisha_laser.__index=function(o,k) local getter=Molisha_laser.__get[k];if getter then return getter(o) end;return Molisha_laser[k] end
Molisha_laser.__newindex=function(o,k,v) local setter=Molisha_laser.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Molisha_laser.__base="MonoBehaviour"
function Molisha_laser:Start()

self.sr=CS.invoke(self,"GetComponent","SpriteRenderer")
self.dam=CS.invoke(self.transform,"GetComponent","Damage7")
CS.invoke(self.sr.material,"SetFloat","_Pos",self.start_pos)
self.Pos=CS.f((self.start_pos * CS.f(1000)))
self.laserhead=CS.invoke(self.transform,"GetChild",0)
self.ps2=CS.invoke(self.laserhead,"GetComponent","ParticleSystem")
end
function Molisha_laser:FixedUpdate()

if ((Sincos.anjian_now[4] and Sincos.anjian_now[5]) and (not Sincos.ifduihua)) then
if (not self.ps2.isPlaying) then
CS.invoke(self.ps2,"Play")
end
if (self.transform.localScale.y <= CS.f(0.96)) then
self.transform.localScale=CS.copy(CS.new("Vector3",CS.f(1),(self.transform.localScale.y + CS.f(0.04)),CS.f(1)))
self.laserhead.localScale=CS.copy(CS.new("Vector3",(self.transform.localScale.y + CS.f(0.04)),CS.f(1),CS.f(1)))
else
self.transform.localScale=CS.copy(CS.new("Vector3",CS.f(1),CS.f(1),CS.f(1)))
self.laserhead.localScale=CS.copy(CS.new("Vector3",CS.f(1),CS.f(1),CS.f(1)))
end
else
if self.ps2.isPlaying then
CS.invoke(self.ps2,"Stop")
end
if (self.transform.localScale.y >= CS.f(0.04)) then
self.transform.localScale=CS.copy(CS.new("Vector3",CS.f(1),(self.transform.localScale.y - CS.f(0.04)),CS.f(1)))
self.laserhead.localScale=CS.copy(CS.new("Vector3",(self.transform.localScale.y - CS.f(0.04)),CS.f(1),CS.f(1)))
else
self.transform.localScale=CS.copy(CS.new("Vector3",CS.f(1),CS.f(0),CS.f(1)))
self.laserhead.localScale=CS.copy(CS.new("Vector3",CS.f(0),CS.f(1),CS.f(1)))
end
end
CS.invoke(self.sr.material,"SetFloat","_Pos",(self.Pos * CS.f(0.001)))
if (Sincos.hyper_time > 0) then
if (not self.ps.isPlaying) then
if (Sincos.anjian_now[4] and Sincos.anjian_now[5]) then
CS.invoke(self.ps,"Play")
end
else
if ((not Sincos.anjian_now[4]) or (not Sincos.anjian_now[5])) then
CS.invoke(self.ps,"Stop")
end
end
self.Pos=CS.f((self.Pos - CS.f(4)))
self.sr.sprite=self.laser_baozou
self.dam_now=self.damage_baozou
self.dam.switch_baozou=true
if (self.dam.color_blue > 1) then
CS.invoke(self.sr.material,"SetFloat","_Bool",CS.f(1))
else
CS.invoke(self.sr.material,"SetFloat","_Bool",(-CS.f(1)))
end
else
if self.ps.isPlaying then
CS.invoke(self.ps,"Stop")
end
self.Pos=CS.f((self.Pos - CS.f(3)))
self.sr.sprite=self.laser
self.dam_now=self.damage
self.dam.switch_baozou=false
if (self.dam.color_blue > 1) then
CS.invoke(self.sr.material,"SetFloat","_Bool",CS.f(1))
else
CS.invoke(self.sr.material,"SetFloat","_Bool",(-CS.f(1)))
end
end
if (self.Pos <= CS.f(0)) then
self.Pos=CS.f(CS.f(500))
end
if (self.transform.localScale.y > CS.f(0.5)) then
self.dam.damage=self.dam_now
else
self.dam.damage=0
end
end
function Molisha_laser.defaults(self)
self.sr=nil
self.Pos=0
self.dam=nil
self.dam_now=0
self.damage=0
self.damage_baozou=0
self.laser=nil
self.laser_baozou=nil
self.start_pos=0
self.ps=nil
self.ps2=nil
self.laserhead=nil
end
-- Molisha_laser2.cs SHA256 8ef8765dd0ac38bb40c7877d46a9ecc1044ab4ad156de4977211e0d11d7382cc
Molisha_laser2={__get={},__set={}}
Molisha_laser2.__index=function(o,k) local getter=Molisha_laser2.__get[k];if getter then return getter(o) end;return Molisha_laser2[k] end
Molisha_laser2.__newindex=function(o,k,v) local setter=Molisha_laser2.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Molisha_laser2.__base="MonoBehaviour"
function Molisha_laser2:Start()

self.sr=CS.invoke(self,"GetComponent","SpriteRenderer")
self.dam=CS.invoke(self.transform,"GetComponent","Damage7_5")
CS.invoke(self.sr.material,"SetFloat","_Pos",self.start_pos)
self.Pos=CS.f((self.start_pos * CS.f(1000)))
self.laserhead=CS.invoke(self.transform,"GetChild",0)
self.ps2=CS.invoke(self.laserhead,"GetComponent","ParticleSystem")
end
function Molisha_laser2:FixedUpdate()

if (Sincos.anjian_now[5] and (not Sincos.ifduihua)) then
if (not self.ps2.isPlaying) then
CS.invoke(self.ps2,"Play")
end
if (self.transform.localScale.y <= CS.f(0.96)) then
self.transform.localScale=CS.copy(CS.new("Vector3",CS.f(1),(self.transform.localScale.y + CS.f(0.04)),CS.f(1)))
self.laserhead.localScale=CS.copy(CS.new("Vector3",(self.transform.localScale.y + CS.f(0.04)),CS.f(1),CS.f(1)))
else
self.transform.localScale=CS.copy(CS.new("Vector3",CS.f(1),CS.f(1),CS.f(1)))
self.laserhead.localScale=CS.copy(CS.new("Vector3",CS.f(1),CS.f(1),CS.f(1)))
end
else
if self.ps2.isPlaying then
CS.invoke(self.ps2,"Stop")
end
if (self.transform.localScale.y >= CS.f(0.04)) then
self.transform.localScale=CS.copy(CS.new("Vector3",CS.f(1),(self.transform.localScale.y - CS.f(0.04)),CS.f(1)))
self.laserhead.localScale=CS.copy(CS.new("Vector3",(self.transform.localScale.y - CS.f(0.04)),CS.f(1),CS.f(1)))
else
self.transform.localScale=CS.copy(CS.new("Vector3",CS.f(1),CS.f(0),CS.f(1)))
self.laserhead.localScale=CS.copy(CS.new("Vector3",CS.f(0),CS.f(1),CS.f(1)))
end
end
if Sincos.anjian_now[4] then
self.damage=self.damage_disu
else
self.damage=self.damage_gaosu
end
CS.invoke(self.sr.material,"SetFloat","_Pos",(self.Pos * CS.f(0.001)))
self.Pos=CS.f((self.Pos - CS.f(3)))
if (self.dam.color_blue > 1) then
CS.invoke(self.sr.material,"SetFloat","_Bool",CS.f(0))
else
CS.invoke(self.sr.material,"SetFloat","_Bool",(-CS.f(1)))
end
if (self.Pos <= CS.f(0)) then
self.Pos=CS.f(CS.f(500))
end
if (self.transform.localScale.y > CS.f(0.5)) then
self.dam.damage=self.damage
else
self.dam.damage=0
end
end
function Molisha_laser2.defaults(self)
self.sr=nil
self.Pos=0
self.dam=nil
self.damage_gaosu=0
self.damage_disu=0
self.damage=0
self.start_pos=0
self.ps2=nil
self.laserhead=nil
end
-- Moshen_kongzhi.cs SHA256 ef0aa4b709c967e4f38f1c315f981dd0c203845718e1a6522b8a247345592ac2
Moshen_kongzhi={__get={},__set={}}
Moshen_kongzhi.__index=function(o,k) local getter=Moshen_kongzhi.__get[k];if getter then return getter(o) end;return Moshen_kongzhi[k] end
Moshen_kongzhi.__newindex=function(o,k,v) local setter=Moshen_kongzhi.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Moshen_kongzhi.__base="MonoBehaviour"
function Moshen_kongzhi:Start()

do
local i=0
while (i <= 3) do
local __break1,__continue1=false,false
repeat
self.sr_l[i]=CS.invoke(self.laser[i],"GetComponent","SpriteRenderer")
self.sr_h[i]=CS.invoke(self.head[i],"GetComponent","SpriteRenderer")
CS.invoke(self.sr_l[i].material,"SetFloat","_Pos",self.start_pianyi[i])
self.pos[i]=self.start_pianyi[i]
until true
if __break1 then break end
i=i+1
end
end
end
function Moshen_kongzhi:FixedUpdate()

do
local i=0
while (i <= 3) do
local __break2,__continue2=false,false
repeat
CS.invoke(self.sr_l[i].material,"SetFloat","_Pos",self.pos[i])
self.pos[i]=(self.pos[i] - CS.f(0.002))
if (self.pos[i] <= CS.f(0)) then
self.pos[i]=CS.f(0.5)
end
CS.invoke(self.laser[i].transform,"Rotate",CS.f(0),CS.f(0),self.zhuansu[i])
CS.invoke(self.head[i].transform,"Rotate",CS.f(0),CS.f(0),self.zhuansu[i])
until true
if __break2 then break end
i=i+1
end
end
end
function Moshen_kongzhi.defaults(self)
self.laser=CS.array(4,function() return nil end)
self.head=CS.array(4,function() return nil end)
self.zhuansu=CS.array(4,function() return 0 end)
self.start_pianyi=CS.array(4,function() return 0 end)
self.sr_l=CS.array(4,function() return nil end)
self.sr_h=CS.array(4,function() return nil end)
self.pos=CS.array(4,function() return 0 end)
end
-- Objectmove.cs SHA256 8d889f93656e5afa40be2d051d631632dfec3a51ffe7bde16032b44bd515eb7d
Objectmove={__get={},__set={}}
Objectmove.__index=function(o,k) local getter=Objectmove.__get[k];if getter then return getter(o) end;return Objectmove[k] end
Objectmove.__newindex=function(o,k,v) local setter=Objectmove.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Objectmove.__base="MonoBehaviour"
function Objectmove:FixedUpdate()

self.chazhi=CS.copy((((CS.new("Vector3",Sincos.zijix,Sincos.zijiy,CS.f(0)) - CS.new("Vector3",self.transform.position.x,self.transform.position.y,CS.f(0)))) / CS.f(3)))
self.transform.position=CS.copy((self.transform.position + self.chazhi))
end
function Objectmove.defaults(self)
self.chazhi=CS.Vector3()
end
-- Objshift.cs SHA256 cc39e9c51c18893283df9943ffb29c503f88243cc8d95ede0afb9d91e2e0bde5
Objshift={__get={},__set={}}
Objshift.__index=function(o,k) local getter=Objshift.__get[k];if getter then return getter(o) end;return Objshift[k] end
Objshift.__newindex=function(o,k,v) local setter=Objshift.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Objshift.__base="MonoBehaviour"
function Objshift:Start()

self.mubiao=CS.copy(self.yuanlaiweiz)
end
function Objshift:FixedUpdate()

self.jiaozhengzuobiao=CS.copy((self.mubiao + CS.new("Vector2",self.transform.parent.position.x,self.transform.parent.position.y)))
self.chazhi2=CS.copy((((self.jiaozhengzuobiao - CS.new("Vector2",self.transform.position.x,self.transform.position.y))) / CS.f(4)))
CS.invoke(self.transform,"Translate",self.chazhi2)
self.mubiao=CS.copy(self.yuanlaiweiz)
CS.invoke(self.transform,"GetComponent","SpriteRenderer").sprite=self.gaosuziji
if Sincos.anjian_now[4] then
self.mubiao=CS.copy(self.yidongdao)
CS.invoke(self.transform,"GetComponent","SpriteRenderer").sprite=self.disuziji
end
end
function Objshift.defaults(self)
self.chazhi2=CS.Vector2()
self.mubiao=CS.Vector2()
self.jiaozhengzuobiao=CS.Vector2()
self.yuanlaiweiz=CS.Vector2()
self.yidongdao=CS.Vector2()
self.gaosuziji=nil
self.disuziji=nil
end
-- Objshift2.cs SHA256 3379789ee89a3eb9c08d9577bb0344b5c9831a957da41e36ede5f3f3caf0c859
Objshift2={__get={},__set={}}
Objshift2.__index=function(o,k) local getter=Objshift2.__get[k];if getter then return getter(o) end;return Objshift2[k] end
Objshift2.__newindex=function(o,k,v) local setter=Objshift2.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Objshift2.__base="MonoBehaviour"
function Objshift2:Start()

self.mubiao=CS.copy(self.yuanlaiweiz)
end
function Objshift2:FixedUpdate()

self.chazhi2=CS.copy((((self.mubiao - CS.new("Vector3",self.transform.localPosition.x,self.transform.localPosition.y,CS.f(0)))) / CS.f(4)))
self.transform.localPosition=CS.copy((self.transform.localPosition + self.chazhi2))
self.mubiao=CS.copy(self.yuanlaiweiz)
CS.invoke(self.transform,"GetComponent","SpriteRenderer").sprite=self.gaosuziji
if Sincos.anjian_now[4] then
self.mubiao=CS.copy(self.yidongdao)
CS.invoke(self.transform,"GetComponent","SpriteRenderer").sprite=self.disuziji
end
end
function Objshift2.defaults(self)
self.chazhi2=CS.Vector3()
self.mubiao=CS.Vector3()
self.yuanlaiweiz=CS.Vector3()
self.yidongdao=CS.Vector3()
self.gaosuziji=nil
self.disuziji=nil
end
-- Objtexiao.cs SHA256 e414fa9add2a7184254e65bebd13834e54186d440a6a2c72ad473d4905b11f0a
Objtexiao={__get={},__set={}}
Objtexiao.__index=function(o,k) local getter=Objtexiao.__get[k];if getter then return getter(o) end;return Objtexiao[k] end
Objtexiao.__newindex=function(o,k,v) local setter=Objtexiao.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Objtexiao.__base="MonoBehaviour"
function Objtexiao:Start()

self.sr=CS.invoke(self,"GetComponent","Transform")
self.sp=CS.invoke(self,"GetComponent","SpriteRenderer")
end
function Objtexiao:FixedUpdate()

self.zhi=CS.f(((CS.invoke(Sincos,"Dsin",CS.invoke(Sincos,"Jiaodu_ads",self.jiao)) * self.A_max) + self.C_base))
self.sr.localScale=CS.copy(CS.new("Vector3",self.zhi,self.zhi,CS.f(1)))
self.jiao=CS.f((self.jiao + self.w_speed))
if (self.jiao > CS.f(360)) then
self.jiao=CS.f((self.jiao - CS.f(360)))
end
self.sp.sprite=self.gaosuziji
if Sincos.anjian_now[4] then
self.sp.sprite=self.disuziji
end
end
function Objtexiao.defaults(self)
self.sr=nil
self.sp=nil
self.jiao=0
self.zhi=0
self.gaosuziji=nil
self.disuziji=nil
self.A_max=0
self.w_speed=0
self.C_base=0
end
-- Objtexiao_daozhuan.cs SHA256 2d780854cf92ad98e0285d07dcf41e518b2fddd3e02cf915194b6f6d53f11c7d
Objtexiao_daozhuan={__get={},__set={}}
Objtexiao_daozhuan.__index=function(o,k) local getter=Objtexiao_daozhuan.__get[k];if getter then return getter(o) end;return Objtexiao_daozhuan[k] end
Objtexiao_daozhuan.__newindex=function(o,k,v) local setter=Objtexiao_daozhuan.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Objtexiao_daozhuan.__base="MonoBehaviour"
function Objtexiao_daozhuan:Start()

self.ty=CS.invoke(self,"GetComponent","Tongyong_xuanzhuan")
self.speed_a=CS.f(self.ty.zhuansu)
self.xuli=CS.invoke(self.transform.parent.parent,"GetComponent","Jitifashezidan_xuli")
end
function Objtexiao_daozhuan:FixedUpdate()

if (self.xuli.time_xuli >= CS.f(self.time)) then
if (self.ty.zhuansu < self.speed) then
self.ty.zhuansu=CS.f((self.ty.zhuansu + CS.f(0.2)))
end
else
if (self.ty.zhuansu > self.speed_a) then
self.ty.zhuansu=CS.f((self.ty.zhuansu - CS.f(0.2)))
end
end
end
function Objtexiao_daozhuan.defaults(self)
self.ty=nil
self.speed=0
self.speed_a=0
self.xuli=nil
self.time=0
end
-- Objtexiao_xuanzhuan.cs SHA256 af12ce43c0fb3365d9239c7a15f282ccb7adde97636a8b93999d1f36e3378dee
Objtexiao_xuanzhuan={__get={},__set={}}
Objtexiao_xuanzhuan.__index=function(o,k) local getter=Objtexiao_xuanzhuan.__get[k];if getter then return getter(o) end;return Objtexiao_xuanzhuan[k] end
Objtexiao_xuanzhuan.__newindex=function(o,k,v) local setter=Objtexiao_xuanzhuan.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Objtexiao_xuanzhuan.__base="MonoBehaviour"
function Objtexiao_xuanzhuan:FixedUpdate()

CS.invoke(self.transform,"Rotate",CS.f(0),CS.f(0),self.a)
end
function Objtexiao_xuanzhuan.defaults(self)
self.a=0
end
-- Objtexiao_xuli.cs SHA256 880782405236bee3cff62d3dee3dd0b2c5d9f73695f5944a5319499b34fbe7a1
Objtexiao_xuli={__get={},__set={}}
Objtexiao_xuli.__index=function(o,k) local getter=Objtexiao_xuli.__get[k];if getter then return getter(o) end;return Objtexiao_xuli[k] end
Objtexiao_xuli.__newindex=function(o,k,v) local setter=Objtexiao_xuli.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Objtexiao_xuli.__base="MonoBehaviour"
function Objtexiao_xuli:Start()

self.xuli=CS.invoke(self.transform.parent.parent,"GetComponent","Jitifashezidan_xuli")
self.sr=CS.invoke(self.transform,"GetComponent","SpriteRenderer")
self.ps=CS.invoke(self.transform.parent,"GetComponent","ParticleSystem")
self.au=CS.invoke(self,"GetComponent","AudioSource")
end
function Objtexiao_xuli:FixedUpdate()

if (self.xuli.time_xuli >= CS.f(self.time)) then
if (not self.a) then
self.a=true
CS.invoke(self.ps,"Play")
end
if ((self.xuli.time_xuli - CS.f(self.time)) <= CS.f(40)) then
local num=(((self.xuli.time_xuli - CS.f(self.time))) * CS.f(0.05))
if (num > self.amax) then
num=CS.f(self.amax)
end
self.sr.color=CS.new("Color",CS.f(1),CS.f(1),CS.f(1),num)
local num2=(CS.f(2.5) - (((self.xuli.time_xuli - CS.f(self.time))) * CS.f(0.025)))
self.transform.localScale=CS.copy(CS.new("Vector3",num2,num2,CS.f(1)))
end
else
if self.a then
self.a=false
CS.invoke(self.ps,"Stop")
end
self.sr.color=CS.new("Color",CS.f(1),CS.f(1),CS.f(1),(self.sr.color.a - CS.f(0.08)))
self.transform.localScale=CS.copy(CS.new("Vector3",(self.transform.localScale.x + CS.f(0.04)),(self.transform.localScale.y + CS.f(0.04)),CS.f(1)))
end
if (self.xuli.time_xuli >= CS.f(self.soundtime)) then
if (not self.b) then
self.b=true
CS.invoke(self.au,"Play")
end
else
self.b=false
end
end
function Objtexiao_xuli.defaults(self)
self.time=0
self.soundtime=0
self.xuli=nil
self.sr=nil
self.ps=nil
self.au=nil
self.a=false
self.b=false
self.amax=0
end
-- Shenzi_laser_ins.cs SHA256 4763206532c08d208632893112875a2da9bf6a2cfc780908504e9e5ecb04ffb9
Shenzi_laser_ins={__get={},__set={}}
Shenzi_laser_ins.__index=function(o,k) local getter=Shenzi_laser_ins.__get[k];if getter then return getter(o) end;return Shenzi_laser_ins[k] end
Shenzi_laser_ins.__newindex=function(o,k,v) local setter=Shenzi_laser_ins.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Shenzi_laser_ins.__base="MonoBehaviour"
function Shenzi_laser_ins:Start()

Sincos.dam6_chengfa=0
end
function Shenzi_laser_ins:FixedUpdate()

if (self.i < self.num) then
if (self.time_jiange > 0) then
self.time_jiange=self.time_jiange-1
else
self.time_jiange=4
CS.invoke(CS.invoke(Object,"Instantiate",self.laser,(self.transform.position + CS.new("Vector3",(CS.f(self.i) * CS.f(0.11)),((CS.f(((-self.i))) * CS.f(0.045)) + CS.f(6)),CS.f(0))),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),(CS.f(90) + (CS.f(((-self.i))) * CS.f(0.5))))),"GetComponent","Damage7_9").list=self
if (self.i ~= 0) then
CS.invoke(CS.invoke(Object,"Instantiate",self.laser,(self.transform.position + CS.new("Vector3",(CS.f(((-self.i))) * CS.f(0.11)),((CS.f(self.i) * CS.f(0.045)) + CS.f(6)),CS.f(0))),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),(CS.f(90) + (CS.f(self.i) * CS.f(0.5))))),"GetComponent","Damage7_9").list=self
end
self.i=self.i+1
end
end
self.time=self.time+1
if (self.time ~= 15) then
do return  end
end
do
local i=0
while (i < self.emy.Count) do
local __break1,__continue1=false,false
repeat
if (not ((self.emy[i] ~= nil))) then
__continue1=true;break
end
if (self.emy[i].sdbj < CS.invoke(Mathf,"Abs",(self.transform.position.x - self.emy[i].transform.position.x))) then
self.dy=CS.f(self.emy[i].transform.position.y)
if (self.dy < (self.transform.position.y + CS.f(0.65))) then
self.dy=CS.f((self.transform.position.y + CS.f(0.65)))
end
if (self.transform.position.x > self.emy[i].transform.position.x) then
CS.invoke(Object,"Instantiate",self.texiao,CS.new("Vector3",(self.emy[i].transform.position.x + self.emy[i].sdbj),self.dy,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(30)))
else
CS.invoke(Object,"Instantiate",self.texiao,CS.new("Vector3",(self.emy[i].transform.position.x - self.emy[i].sdbj),self.dy,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(30)))
end
else
self.dy=CS.f((self.emy[i].transform.position.y - CS.invoke(Mathf,"Pow",(CS.invoke(Mathf,"Pow",self.emy[i].sdbj,CS.f(2)) - CS.invoke(Mathf,"Pow",CS.invoke(Mathf,"Abs",(self.transform.position.x - self.emy[i].transform.position.x)),CS.f(2))),CS.f(0.5))))
if (self.dy < (self.transform.position.y + CS.f(0.65))) then
self.dy=CS.f((self.transform.position.y + CS.f(0.65)))
end
CS.invoke(Object,"Instantiate",self.texiao,CS.new("Vector3",self.transform.position.x,self.dy,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(30)))
end
until true
if __break1 then break end
i=i+1
end
end
CS.invoke(self.emy,"Clear")
do
local j=0
while (j < self.bos.Count) do
local __break2,__continue2=false,false
repeat
if (not ((self.bos[j] ~= nil))) then
__continue2=true;break
end
if (self.bos[j].sdbj < CS.invoke(Mathf,"Abs",(self.transform.position.x - self.bos[j].transform.position.x))) then
self.dy=CS.f(self.bos[j].transform.position.y)
if (self.dy < (self.transform.position.y + CS.f(0.65))) then
self.dy=CS.f((self.transform.position.y + CS.f(0.65)))
end
if (self.transform.position.x > self.bos[j].transform.position.x) then
CS.invoke(Object,"Instantiate",self.texiao,CS.new("Vector3",(self.bos[j].transform.position.x + self.bos[j].sdbj),self.dy,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(30)))
CS.invoke(Object,"Instantiate",self.texiao,CS.new("Vector3",(self.bos[j].transform.position.x + self.bos[j].sdbj),self.dy,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(120)))
else
CS.invoke(Object,"Instantiate",self.texiao,CS.new("Vector3",(self.bos[j].transform.position.x - self.bos[j].sdbj),self.dy,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(30)))
CS.invoke(Object,"Instantiate",self.texiao,CS.new("Vector3",(self.bos[j].transform.position.x - self.bos[j].sdbj),self.dy,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(120)))
end
else
self.dy=CS.f((self.bos[j].transform.position.y - CS.invoke(Mathf,"Pow",(CS.invoke(Mathf,"Pow",self.bos[j].sdbj,CS.f(2)) - CS.invoke(Mathf,"Pow",CS.invoke(Mathf,"Abs",(self.transform.position.x - self.bos[j].transform.position.x)),CS.f(2))),CS.f(0.5))))
if (self.dy < (self.transform.position.y + CS.f(0.65))) then
self.dy=CS.f((self.transform.position.y + CS.f(0.65)))
end
CS.invoke(Object,"Instantiate",self.texiao,CS.new("Vector3",self.transform.position.x,self.dy,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(30)))
CS.invoke(Object,"Instantiate",self.texiao,CS.new("Vector3",self.transform.position.x,self.dy,CS.f(0)),CS.invoke(Quaternion,"Euler",CS.f(0),CS.f(0),CS.f(120)))
end
until true
if __break2 then break end
j=j+1
end
end
CS.invoke(self.bos,"Clear")
self.time=0
end
function Shenzi_laser_ins.defaults(self)
self.laser=nil
self.time_jiange=20
self.i=0
self.num=0
self.emy=CS.List({})
self.bos=CS.List({})
self.texiao=nil
self.dy=0
self.time=0
end
-- Shenzi_xuli_kuoda.cs SHA256 ce519d2c3649e29c3ac571243e61ae64b6219222dddee9efa06bd44e1d1d5c26
Shenzi_xuli_kuoda={__get={},__set={}}
Shenzi_xuli_kuoda.__index=function(o,k) local getter=Shenzi_xuli_kuoda.__get[k];if getter then return getter(o) end;return Shenzi_xuli_kuoda[k] end
Shenzi_xuli_kuoda.__newindex=function(o,k,v) local setter=Shenzi_xuli_kuoda.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Shenzi_xuli_kuoda.__base="MonoBehaviour"
function Shenzi_xuli_kuoda:Start()

self.d5=CS.invoke(self,"GetComponent","Damage5")
self.ty=CS.invoke(self,"GetComponent","Tongyong_suofang")
self.ps=CS.invoke(self,"GetComponent","ParticleSystem")
if (Sincos.suipian_beilv_hong > CS.f(1)) then
local num=((((Sincos.suipian_beilv_hong - CS.f(1))) / CS.f(2)) + CS.f(1))
if (self.ty ~= nil) then
self.ty.mubiao_x=CS.f((self.ty.mubiao_x * num))
self.ty.mubiao_y=CS.f((self.ty.mubiao_y * num))
end
if self.fangdaziji then
self.transform.localScale=CS.copy(CS.new("Vector3",(self.transform.localScale.x * num),(self.transform.localScale.y * num),CS.f(1)))
end
if (self.d5 ~= nil) then
self.d5.damage=CS.trunc(((CS.f(self.d5.damage) * num)))
self.d5.damage_r_nei=CS.f((self.d5.damage_r_nei * num))
self.d5.damage_r_wai=CS.f((self.d5.damage_r_wai * num))
end
if (self.ps ~= nil) then
local emission=self.ps.emission
emission.rateOverTime=(emission.rateOverTime.constant * num)
local shape=self.ps.shape
shape.radius=(shape.radius * num)
end
end
end
function Shenzi_xuli_kuoda.defaults(self)
self.d5=nil
self.ty=nil
self.fangdaziji=false
self.ps=nil
end
-- Tong_creat_duli.cs SHA256 46afa16c068978e3bda2da4df389774e2b86c12aed8e3d71f8a3184991cce749
Tong_creat_duli={__get={},__set={}}
Tong_creat_duli.__index=function(o,k) local getter=Tong_creat_duli.__get[k];if getter then return getter(o) end;return Tong_creat_duli[k] end
Tong_creat_duli.__newindex=function(o,k,v) local setter=Tong_creat_duli.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Tong_creat_duli.__base="MonoBehaviour"
function Tong_creat_duli:FixedUpdate()

if (self.creat_time == 0) then
if (not self.as_child) then
if (not self.use_self_pos) then
CS.invoke(Object,"Instantiate",self.obj,self.transform.position,self.transform.rotation)
else
CS.invoke(Object,"Instantiate",self.obj)
end
else
if (not self.use_self_pos) then
CS.invoke(Object,"Instantiate",self.obj,self.transform.position,self.transform.rotation).transform.parent=self.father.transform
else
CS.invoke(Object,"Instantiate",self.obj).transform.parent=self.father.transform
end
end
CS.invoke(UnityEngine.Object,"Destroy",self)
end
self.creat_time=self.creat_time-1
end
function Tong_creat_duli.defaults(self)
self.creat_time=0
self.obj=nil
self.as_child=false
self.father=nil
self.use_self_pos=false
end
-- Tongyong_colorchange_sprite.cs SHA256 dd5213b3e97bda664af2a1382736741dac02ca12809ced41eb0333aa73edbbfa
Tongyong_colorchange_sprite={__get={},__set={}}
Tongyong_colorchange_sprite.__index=function(o,k) local getter=Tongyong_colorchange_sprite.__get[k];if getter then return getter(o) end;return Tongyong_colorchange_sprite[k] end
Tongyong_colorchange_sprite.__newindex=function(o,k,v) local setter=Tongyong_colorchange_sprite.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Tongyong_colorchange_sprite.__base="MonoBehaviour"
function Tongyong_colorchange_sprite:Start()

self.sr=CS.invoke(self,"GetComponent","SpriteRenderer")
self.colorfendu=CS.new("Color",(((self.sr.color.r - self.mubiao_color.r)) / CS.f(self.time_long)),(((self.sr.color.g - self.mubiao_color.g)) / CS.f(self.time_long)),(((self.sr.color.b - self.mubiao_color.b)) / CS.f(self.time_long)),(((self.sr.color.a - self.mubiao_color.a)) / CS.f(self.time_long)))
end
function Tongyong_colorchange_sprite:FixedUpdate()

if ((self.time >= self.time_yanshi) and (self.sr ~= nil)) then
self.sr.color=CS.new("Color",(self.sr.color.r - self.colorfendu.r),(self.sr.color.g - self.colorfendu.g),(self.sr.color.b - self.colorfendu.b),(self.sr.color.a - self.colorfendu.a))
end
if (self.time == (self.time_yanshi + self.time_long)) then
if (self.sr ~= nil) then
self.sr.color=self.mubiao_color
end
CS.invoke(UnityEngine.Object,"Destroy",self)
end
self.time=self.time+1
end
function Tongyong_colorchange_sprite.defaults(self)
self.time=0
self.time_long=0
self.time_yanshi=0
self.mubiao_color=CS.Color()
self.colorfendu=CS.Color()
self.sr=nil
end
-- Tongyong_death.cs SHA256 7a140b5383d7cff8b2a8e677601361e8578473ddc9c1a4d80932697a1c6b0059
Tongyong_death={__get={},__set={}}
Tongyong_death.__index=function(o,k) local getter=Tongyong_death.__get[k];if getter then return getter(o) end;return Tongyong_death[k] end
Tongyong_death.__newindex=function(o,k,v) local setter=Tongyong_death.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Tongyong_death.__base="MonoBehaviour"
function Tongyong_death:FixedUpdate()

self.time=self.time-1
if (self.time == (-1)) then
CS.invoke(UnityEngine.Object,"Destroy",self.gameObject)
end
end
function Tongyong_death.defaults(self)
self.time=0
end
-- Tongyong_gensui_gameobj.cs SHA256 e21cbc028ad3cb0df804f04f92574b55c5ed5c476e00e9e93025658450fb0c89
Tongyong_gensui_gameobj={__get={},__set={}}
Tongyong_gensui_gameobj.__index=function(o,k) local getter=Tongyong_gensui_gameobj.__get[k];if getter then return getter(o) end;return Tongyong_gensui_gameobj[k] end
Tongyong_gensui_gameobj.__newindex=function(o,k,v) local setter=Tongyong_gensui_gameobj.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Tongyong_gensui_gameobj.__base="MonoBehaviour"
function Tongyong_gensui_gameobj:Start()

if ((Sincos.camera_3D ~= nil) and self.if_camera) then
self.obj=Sincos.camera_3D.gameObject
end
end
function Tongyong_gensui_gameobj:FixedUpdate()

if (self.obj ~= nil) then
self.transform.position=CS.copy((self.obj.transform.position + self.pianyi))
end
end
function Tongyong_gensui_gameobj.defaults(self)
self.obj=nil
self.pianyi=CS.Vector3()
self.if_camera=false
end
-- Tongyong_gensuijizi.cs SHA256 22fbf59d458b44ac277042de179c276875de4358b67cf10046c3f530bc1ff757
Tongyong_gensuijizi={__get={},__set={}}
Tongyong_gensuijizi.__index=function(o,k) local getter=Tongyong_gensuijizi.__get[k];if getter then return getter(o) end;return Tongyong_gensuijizi[k] end
Tongyong_gensuijizi.__newindex=function(o,k,v) local setter=Tongyong_gensuijizi.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Tongyong_gensuijizi.__base="MonoBehaviour"
function Tongyong_gensuijizi:Start()


end
function Tongyong_gensuijizi:FixedUpdate()

self.transform.position=CS.copy(CS.new("Vector3",Sincos.zijix,Sincos.zijiy,self.transform.position.z))
end
function Tongyong_gensuijizi.defaults(self)
end
-- Tongyong_jianxianjianyin.cs SHA256 594a693df9007e73381d518be83766c7015ae6e774c00205f9413996f1e64f10
Tongyong_jianxianjianyin={__get={},__set={}}
Tongyong_jianxianjianyin.__index=function(o,k) local getter=Tongyong_jianxianjianyin.__get[k];if getter then return getter(o) end;return Tongyong_jianxianjianyin[k] end
Tongyong_jianxianjianyin.__newindex=function(o,k,v) local setter=Tongyong_jianxianjianyin.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Tongyong_jianxianjianyin.__base="MonoBehaviour"
function Tongyong_jianxianjianyin:Start()

self.sr=CS.invoke(self,"GetComponent","SpriteRenderer")
if (self.a_kuadu ~= CS.f(0)) then
self.time_fendu=CS.f((self.a_kuadu / CS.f(self.time_long)))
else
self.time_fendu=CS.f((CS.f(1) / CS.f(self.time_long)))
end
if self.yingyongziwuti then
self.sr_zi=CS.invoke(self.transform,"GetComponentsInChildren")
end
end
function Tongyong_jianxianjianyin:FixedUpdate()

if (self.time >= self.time_yanshi) then
if self.jianxian_or_jianyin then
if (self.sr ~= nil) then
self.sr.color=(self.sr.color + CS.new("Color",CS.f(0),CS.f(0),CS.f(0),self.time_fendu))
end
if self.yingyongziwuti then
do
local i=0
while (i < self.sr_zi.Length) do
local __break1,__continue1=false,false
repeat
if (self.sr_zi[i] ~= nil) then
self.sr_zi[i].color=(self.sr_zi[i].color + CS.new("Color",CS.f(0),CS.f(0),CS.f(0),self.time_fendu))
end
until true
if __break1 then break end
i=i+1
end
end
end
else
if (self.sr ~= nil) then
self.sr.color=(self.sr.color - CS.new("Color",CS.f(0),CS.f(0),CS.f(0),self.time_fendu))
end
if self.yingyongziwuti then
do
local j=0
while (j < self.sr_zi.Length) do
local __break2,__continue2=false,false
repeat
if (self.sr_zi[j] ~= nil) then
self.sr_zi[j].color=(self.sr_zi[j].color - CS.new("Color",CS.f(0),CS.f(0),CS.f(0),self.time_fendu))
end
until true
if __break2 then break end
j=j+1
end
end
end
end
end
if (self.time >= (self.time_yanshi + self.time_long)) then
if (self.a_kuadu == CS.f(0)) then
if self.jianxian_or_jianyin then
if (self.sr ~= nil) then
self.sr.color=CS.new("Color",self.sr.color.r,self.sr.color.g,self.sr.color.b,CS.f(1))
end
if self.yingyongziwuti then
do
local k=0
while (k < self.sr_zi.Length) do
local __break3,__continue3=false,false
repeat
if (self.sr_zi[k] ~= nil) then
self.sr_zi[k].color=CS.new("Color",self.sr.color.r,self.sr.color.g,self.sr.color.b,CS.f(1))
end
until true
if __break3 then break end
k=k+1
end
end
end
else
if (self.sr ~= nil) then
self.sr.color=CS.new("Color",self.sr.color.r,self.sr.color.g,self.sr.color.b,CS.f(0))
end
if self.yingyongziwuti then
do
local l=0
while (l < self.sr_zi.Length) do
local __break4,__continue4=false,false
repeat
if (self.sr_zi[l] ~= nil) then
self.sr_zi[l].color=CS.new("Color",self.sr.color.r,self.sr.color.g,self.sr.color.b,CS.f(0))
end
until true
if __break4 then break end
l=l+1
end
end
end
end
else
if self.jianxian_or_jianyin then
if (self.sr ~= nil) then
self.sr.color=CS.new("Color",self.sr.color.r,self.sr.color.g,self.sr.color.b,self.a_kuadu)
end
if self.yingyongziwuti then
do
local m=0
while (m < self.sr_zi.Length) do
local __break5,__continue5=false,false
repeat
if (self.sr_zi[m] ~= nil) then
self.sr_zi[m].color=CS.new("Color",self.sr.color.r,self.sr.color.g,self.sr.color.b,self.a_kuadu)
end
until true
if __break5 then break end
m=m+1
end
end
end
else
if (self.sr ~= nil) then
self.sr.color=CS.new("Color",self.sr.color.r,self.sr.color.g,self.sr.color.b,(CS.f(1) - self.a_kuadu))
end
if self.yingyongziwuti then
do
local n=0
while (n < self.sr_zi.Length) do
local __break6,__continue6=false,false
repeat
if (self.sr_zi[n] ~= nil) then
self.sr_zi[n].color=CS.new("Color",self.sr.color.r,self.sr.color.g,self.sr.color.b,(CS.f(1) - self.a_kuadu))
end
until true
if __break6 then break end
n=n+1
end
end
end
end
end
if self.destroyRootOnComplete then
CS.invoke(UnityEngine.Object,"Destroy",self.transform.root.gameObject)
else
CS.invoke(UnityEngine.Object,"Destroy",self)
end
end
self.time=self.time+1
end
function Tongyong_jianxianjianyin.defaults(self)
self.time=0
self.time_long=0
self.time_yanshi=0
self.jianxian_or_jianyin=false
self.yingyongziwuti=false
self.a_kuadu=0
self.destroyRootOnComplete=false
self.time_fendu=0
self.sr=nil
self.sr_zi=nil
end
-- Tongyong_setchaoxiang.cs SHA256 7cf027990eb48b191522349422fee3bb40204c114a87d5d70525c50fd6c09ecf
Tongyong_setchaoxiang={__get={},__set={}}
Tongyong_setchaoxiang.__index=function(o,k) local getter=Tongyong_setchaoxiang.__get[k];if getter then return getter(o) end;return Tongyong_setchaoxiang[k] end
Tongyong_setchaoxiang.__newindex=function(o,k,v) local setter=Tongyong_setchaoxiang.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Tongyong_setchaoxiang.__base="MonoBehaviour"
function Tongyong_setchaoxiang:Start()


end
function Tongyong_setchaoxiang:FixedUpdate()

if (self.time == 0) then
local vector=CS.copy(self.transform.rotation.eulerAngles)
if self.ifset then
vector=CS.copy(CS.new("Vector3",vector.x,vector.y,self.chaoxiang_set))
end
vector=CS.copy(CS.new("Vector3",vector.x,vector.y,((vector.z + self.chaoxiang_add) + CS.invoke(UnityEngine.Random,"Range",(CS.f(0) - self.chaoxiang_add_radom),self.chaoxiang_add_radom))))
if (self.if_fanzhuan_x and (CS.invoke(UnityEngine.Random,"Range",CS.f(0),CS.f(1)) > CS.f(0.5))) then
vector.x=CS.f((vector.x + CS.f(180)))
end
if (self.if_fanzhuan_y and (CS.invoke(UnityEngine.Random,"Range",CS.f(0),CS.f(1)) > CS.f(0.5))) then
vector.y=CS.f((vector.y + CS.f(180)))
end
self.transform.rotation=CS.invoke(Quaternion,"Euler",vector.x,vector.y,vector.z)
CS.invoke(UnityEngine.Object,"Destroy",self)
end
self.time=self.time-1
end
function Tongyong_setchaoxiang.defaults(self)
self.time=0
self.ifset=false
self.chaoxiang_set=0
self.chaoxiang_add=0
self.chaoxiang_add_radom=0
self.if_fanzhuan_x=false
self.if_fanzhuan_y=false
end
-- Tongyong_shanshuo.cs SHA256 f8103a13e1416da350bb8cd683566e268deba493dbe5e6dd6a7e0467f2109ece
Tongyong_shanshuo={__get={},__set={}}
Tongyong_shanshuo.__index=function(o,k) local getter=Tongyong_shanshuo.__get[k];if getter then return getter(o) end;return Tongyong_shanshuo[k] end
Tongyong_shanshuo.__newindex=function(o,k,v) local setter=Tongyong_shanshuo.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Tongyong_shanshuo.__base="MonoBehaviour"
function Tongyong_shanshuo:Start()


end
function Tongyong_shanshuo:FixedUpdate()

self.transform.localScale=CS.copy(CS.new("Vector3",(self.scale_base + CS.invoke(UnityEngine.Random,"Range",CS.f(0),self.scale_add)),(self.scale_base + CS.invoke(UnityEngine.Random,"Range",CS.f(0),self.scale_add)),CS.f(1)))
end
function Tongyong_shanshuo.defaults(self)
self.scale_base=0
self.scale_add=0
end
-- Tongyong_suofang.cs SHA256 c86a256659ca1be2e2c6b37120a1f34b422113af87ae41a48d795954cb844f54
Tongyong_suofang={__get={},__set={}}
Tongyong_suofang.__index=function(o,k) local getter=Tongyong_suofang.__get[k];if getter then return getter(o) end;return Tongyong_suofang[k] end
Tongyong_suofang.__newindex=function(o,k,v) local setter=Tongyong_suofang.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Tongyong_suofang.__base="MonoBehaviour"
function Tongyong_suofang:FixedUpdate()

if (self.time == self.time_yanshi) then
self.time_fendu=CS.f((CS.f(1) / CS.f(self.time_chixu)))
self.fendu_x=CS.f((((self.transform.localScale.x - self.mubiao_x)) * self.time_fendu))
self.fendu_y=CS.f((((self.transform.localScale.y - self.mubiao_y)) * self.time_fendu))
self.a_x=CS.f((self.transform.localScale.x - self.mubiao_x))
self.a_y=CS.f((self.transform.localScale.y - self.mubiao_y))
end
if self.zhijie_or_sin then
if (self.time >= self.time_yanshi) then
self.transform.localScale=CS.copy((self.transform.localScale - CS.new("Vector3",self.fendu_x,self.fendu_y,CS.f(0))))
end
if (self.time == (self.time_chixu + self.time_yanshi)) then
CS.invoke(UnityEngine.Object,"Destroy",self)
end
else
if (self.time >= self.time_yanshi) then
self.fendu_x=CS.f((((self.a_x * MathF.PI) * ((CS.f(0.5) * self.time_fendu))) * CS.invoke(Mathf,"Sin",((MathF.PI * self.time_fendu) * CS.f(((self.time - self.time_yanshi)))))))
self.fendu_y=CS.f((((self.a_y * MathF.PI) * ((CS.f(0.5) * self.time_fendu))) * CS.invoke(Mathf,"Sin",((MathF.PI * self.time_fendu) * CS.f(((self.time - self.time_yanshi)))))))
self.transform.localScale=CS.copy((self.transform.localScale - CS.new("Vector3",self.fendu_x,self.fendu_y,CS.f(0))))
end
if (self.time == (self.time_chixu + self.time_yanshi)) then
self.transform.localScale=CS.copy(CS.new("Vector3",self.mubiao_x,self.mubiao_y,CS.f(1)))
CS.invoke(UnityEngine.Object,"Destroy",self)
end
end
self.time=self.time+1
end
function Tongyong_suofang.defaults(self)
self.time_chixu=0
self.time_yanshi=0
self.mubiao_x=0
self.mubiao_y=0
self.zhijie_or_sin=false
self.time=0
self.time_fendu=0
self.fendu_x=0
self.fendu_y=0
self.a_x=0
self.a_y=0
end
-- Tongyong_xuanzhuan.cs SHA256 2a7cade180cb9af20df15688472a6b142d706846db0ed5cfd0566938b001f1bf
Tongyong_xuanzhuan={__get={},__set={}}
Tongyong_xuanzhuan.__index=function(o,k) local getter=Tongyong_xuanzhuan.__get[k];if getter then return getter(o) end;return Tongyong_xuanzhuan[k] end
Tongyong_xuanzhuan.__newindex=function(o,k,v) local setter=Tongyong_xuanzhuan.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Tongyong_xuanzhuan.__base="MonoBehaviour"
function Tongyong_xuanzhuan:FixedUpdate()

CS.invoke(self.transform,"Rotate",CS.f(0),CS.f(0),self.zhuansu)
end
function Tongyong_xuanzhuan.defaults(self)
self.zhuansu=0
end
-- Tongyong_xuanzhuan_change.cs SHA256 41cfd1fee774d1b64e1d9c2367741a6bd1618aa68514c79f892b520a94ec4c7e
Tongyong_xuanzhuan_change={__get={},__set={}}
Tongyong_xuanzhuan_change.__index=function(o,k) local getter=Tongyong_xuanzhuan_change.__get[k];if getter then return getter(o) end;return Tongyong_xuanzhuan_change[k] end
Tongyong_xuanzhuan_change.__newindex=function(o,k,v) local setter=Tongyong_xuanzhuan_change.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Tongyong_xuanzhuan_change.__base="MonoBehaviour"
function Tongyong_xuanzhuan_change:Start()

self.ty=CS.invoke(self,"GetComponent","Tongyong_xuanzhuan")
end
function Tongyong_xuanzhuan_change:FixedUpdate()

if (self.time == self.time_start) then
if (not self.aim_or_add) then
self.speed_per=CS.f((((self.val - self.ty.zhuansu)) / CS.f(self.time_long)))
else
self.speed_per=CS.f((self.val / CS.f(self.time_long)))
end
end
if (self.time >= self.time_start) then
self.ty.zhuansu=CS.f((self.ty.zhuansu + self.speed_per))
self.time_long=self.time_long-1
if (self.time_long <= 0) then
CS.invoke(UnityEngine.Object,"Destroy",self)
end
end
self.time=self.time+1
end
function Tongyong_xuanzhuan_change.defaults(self)
self.aim_or_add=false
self.ty=nil
self.val=0
self.time_start=0
self.time_long=0
self.time=0
self.speed_per=0
end
-- Tongyong_xuanzhuan_random.cs SHA256 7189576801d2991734fb63e7859fac240ed138206c6a798060580b562ba38b97
Tongyong_xuanzhuan_random={__get={},__set={}}
Tongyong_xuanzhuan_random.__index=function(o,k) local getter=Tongyong_xuanzhuan_random.__get[k];if getter then return getter(o) end;return Tongyong_xuanzhuan_random[k] end
Tongyong_xuanzhuan_random.__newindex=function(o,k,v) local setter=Tongyong_xuanzhuan_random.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Tongyong_xuanzhuan_random.__base="MonoBehaviour"
function Tongyong_xuanzhuan_random:Start()

self.zhuansu=CS.f(CS.invoke(Sincos,"Seedrandom",self.zhuansu_range_min,self.zhuansu_range_max))
if (self.shuangxiang and (CS.invoke(Sincos,"Seedrandom",CS.f(0),CS.f(1)) > CS.f(0.5))) then
self.zhuansu=CS.f((CS.f(0) - self.zhuansu))
end
end
function Tongyong_xuanzhuan_random:FixedUpdate()

CS.invoke(self.transform,"Rotate",CS.f(0),CS.f(0),self.zhuansu)
end
function Tongyong_xuanzhuan_random.defaults(self)
self.zhuansu_range_max=0
self.zhuansu_range_min=0
self.shuangxiang=false
self.zhuansu=0
end
-- bailian_xulifanweikuoda.cs SHA256 9c3a1dab6cf47fa0536403c44d745d157754241f400a4a7a3fdf0909ed17093f
bailian_xulifanweikuoda={__get={},__set={}}
bailian_xulifanweikuoda.__index=function(o,k) local getter=bailian_xulifanweikuoda.__get[k];if getter then return getter(o) end;return bailian_xulifanweikuoda[k] end
bailian_xulifanweikuoda.__newindex=function(o,k,v) local setter=bailian_xulifanweikuoda.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
bailian_xulifanweikuoda.__base="MonoBehaviour"
function bailian_xulifanweikuoda:Start()

self.d4=CS.invoke(self,"GetComponent","Damage4")
self.ba=CS.invoke(self,"GetComponent","Bullet_xiaoshi_time")
self.bb=CS.invoke(self,"GetComponent","Tongyong_suofang")
if (Sincos.suipian_beilv_zi > CS.f(1)) then
local num=(((((((Sincos.suipian_beilv_zi - CS.f(1))) / CS.f(2)) + CS.f(1))) * CS.f(1.3)) + CS.f(0.6))
self.transform.localScale=CS.copy(CS.new("Vector3",(self.transform.localScale.x * num),(self.transform.localScale.y * num),CS.f(1)))
self.ba.fangda=CS.f((self.ba.fangda * num))
if (self.bb ~= nil) then
self.bb.mubiao_x=CS.f((self.bb.mubiao_x * num))
self.bb.mubiao_y=CS.f((self.bb.mubiao_y * num))
end
if (self.d4 ~= nil) then
self.d4.damage=CS.trunc(((CS.f(self.d4.damage) * num)))
end
end
end
function bailian_xulifanweikuoda.defaults(self)
self.ba=nil
self.bb=nil
self.d4=nil
end
-- jitifashezidan_zhuqiang.cs SHA256 51ae72cc445a016a949c8d9f2d9b37aea49cf99d851ef3d9896df9292ac5b574
jitifashezidan_zhuqiang={__get={},__set={}}
jitifashezidan_zhuqiang.__index=function(o,k) local getter=jitifashezidan_zhuqiang.__get[k];if getter then return getter(o) end;return jitifashezidan_zhuqiang[k] end
jitifashezidan_zhuqiang.__newindex=function(o,k,v) local setter=jitifashezidan_zhuqiang.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
jitifashezidan_zhuqiang.__base="MonoBehaviour"
function jitifashezidan_zhuqiang:FixedUpdate()

if ((Sincos.anjian_now[5] and (not Sincos.ifduihua)) and (CS.rem(Sincos.gametime,self.zhouqi) == 0)) then
if Sincos.steam_1shoot_now then
Sincos.steam_1shoot=false
end
if (not Sincos.if_change) then
CS.invoke(Sincos,"Ins_zhuqiang",self.transform.position,self.zhuqiang_death,self.zhuqiang,self.chongnengadd_open)
else
CS.invoke(Sincos,"Ins_zhuqiang",self.transform.position,self.zhuqiang_death_B,self.zhuqiang_B,self.chongnengadd_open)
end
end
end
function jitifashezidan_zhuqiang.defaults(self)
self.zhouqi=0
self.zhuqiang=nil
self.zhuqiang_death=nil
self.zhuqiang_B=nil
self.zhuqiang_death_B=nil
self.chongnengadd_open=false
end
return _ENV
end
