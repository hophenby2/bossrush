-- Kill real enemy classes and verify original FX stay visual and expire.
local T={}
local pending,created={},{}
local level,count,expected
local baseNew=New
New=function(class,...)
    local o=baseNew(class,...)
    if o.group==GROUP.GHOST and (o.source_enemy_death or o.break_type or o.img and tostring(o.img):find('_enemy_death_effect_',1,true)) then created[#created+1]={object=o,class=o.class,token=o.effect or o.nodes or o.parts or o.break_type or o.img} end
    return o
end
local function enqueue(v) pending[#pending+1]=v end
local function spawn(p,v)
    local x,y=-140+(count%7)*45,70-math.floor(count/7)*40
    if level==35 then
        local R=TH37.runtime
        local o=New(R.classes.fairy,R.stageState(1),{type=v,x=x+224,y=240-y,speed=0,speedf=0,life=1000,hp=1,id=-1})
        object.Kill(o)
    elseif level==36 then
        local R=TH38.runtime
        local o=New(R.classes.fairy,{c={closed=false},alive=true,kind='enemy',enemyType=v,enemyStyle=1,
            x=x/48+4.5,y=y/48-4.8,life=1,collision=true,age=1,immune=0,hit=.65,rotation=90,alpha=100,red=100,green=100,blue=100,scaleX=1,scaleY=1})
        object.Kill(o)
    elseif level==37 then
        local R=TH39.runtime
        if type(v)=='table' then R.enemyDeathEffect({x=x,y=y,mhj={x=x*1.5+336,y=360-y*1.5,speed=0,speedf=0,type=1}},1,v[1])
        else
            local o=New(R.classes.fairy,R.stageState(1),{type=v,x=x*1.5+336,y=360-y*1.5,speed=0,speedf=0,life=1000,hp=1,id=-1,events={}})
            object.Kill(o)
        end
    elseif level==38 then
        _editor_class.TH40.native.enemyDeath({enemy='EnemyA'..v,x=x,y=y,age=count,clear_radius=0,run={bullets={}}})
    elseif level==39 then local E=_editor_class.TH41.source;E.New(E.enemy_death_ef,v,x,y,1,true)
    elseif level==41 then local E=TH43.runtime.env;E.New(E.enemy_death_ef,v,x,y,1,true) end
    count=count+1
end
function T.before(p)
    local t=stage.current_stage.timer;p.protect=100000
    if t==5 then
        level=p.native_level;count=0
        if level==35 then local seen={};for i,c in ipairs(TH37.runtime.data.enemyTypes) do if not seen[c[12]] then seen[c[12]]=true;enqueue(i) end end
        elseif level==36 then
            local D=dofile('mod/GAME/th38/enemy_death_data.lua');local seen={}
            for i,n in pairs(D.enemies) do if D.deaths[n] and not seen[n] then seen[n]=true;enqueue(i) end end
        elseif level==37 then
            local seen={};for i,c in ipairs(TH39.runtime.data.enemyTypes) do if not seen[c[17]] then seen[c[17]]=true;enqueue(i) end end
            for _,n in ipairs({56,68,70,88,89,90,91,92,424}) do enqueue({n}) end
        elseif level==38 then for i=0,4 do enqueue(i) end
        elseif level==39 then for i=1,8 do enqueue(i) end
        elseif level==41 then for i=1,24 do enqueue(i) end end
        expected=#pending;assert(expected>0)
    end
    if t>=10 and (t-10)%4==0 and #pending>0 then spawn(p,table.remove(pending,1)) end
end
function T.after() end
function T.checkpoint()
    assert(count==expected and #created>=expected,('原始敌机击破没有被调用：%d/%d, effects=%d'):format(count,expected,#created))
    local alive=0
    for _,record in ipairs(created) do
        local o=record.object
        if IsValid(o) and o.class==record.class and (o.effect or o.nodes or o.parts or o.break_type or o.img)==record.token then
            alive=alive+1;assert(o.group==GROUP.GHOST and not o.colli,'击破特效产生碰撞')
            assert(o.timer<300,'击破特效没有回收')
        end
    end
    lstg.SystemLog(('SOURCE_ENEMY: level=%d kills=%d effects=%d alive=%d'):format(level,count,#created,alive))
end
return T
