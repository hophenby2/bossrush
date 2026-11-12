-- 只在内存载入真实注册表，导出顺序模式的波表归属；不访问玩家数据。
-- 载入真实注册与练习菜单，验证原作入口、历史槽位、阶段顺序和道中波次分段。
-- 只使用内存中的成绩表，不读写User/或replay/。
arg[1]='original-practice-registry'
local file=assert(io.open('tools/check_stage.lua','rb'));local source=file:read('*a');file:close()
assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/lib/Ltask.lua')
dofile('THlib/enemy/boss_card.lua')
_sc_table,_sc_pr_table={},{}
local tracing,events,tick=false,{},0
local serialize
local originalNew=New
local controllerClass,controller
New=function(cls,...)
    if tracing then
        if cls==controllerClass then
            local _,x,y,main=...
            local p={_live=true,timer=0,class=cls,ecs={base={x=0,y=0},off={x=x,y=y}},
                I0=0,I1=0,I2=0,I3=0,F0=0,F1=0,F2=0,F3=0}
            task.New(p,function() main(p) end)
            controller=p
            return p
        end
        events[#events+1]={tick=tick,cls=cls,payload=tostring(cls)..serialize({...})}
        return {_live=true,timer=0,class=cls,ecs={base={x=0,y=0},off={x=0,y=0}}}
    end
    return originalNew(cls,...)
end
dofile('mod/_editor_output.lua')
for game=31,35 do dofile('mod/GAME/th'..game..'.lua') end
dofile('mod/GAME/th38.lua')
OriginalStageFlow.install()
local function find(fn,seen)
 if seen[fn] then return end;seen[fn]=true
 for i=1,100 do
  local key,value=debug.getupvalue(fn,i);if not key then break end
  if type(value)=='table' and (key:match('^WAVE') or key=='W7' or key=='W8') then return value end
 end
 for i=1,100 do
  local key,value=debug.getupvalue(fn,i);if not key then break end
  if type(value)=='function' then local result=find(value,seen);if result then return result end end
 end
end
for _,id in ipairs({3400,3401,3402,3403,3404,3405,3406,3407}) do
 for _,unit in ipairs(_sc_pr_table[32]) do
  local c=unit.sc_group[1].card
  if c.card_id==id then
   local waves=assert(find(c.init,{}),'未找到波表'..id)
   local rows={}
   for _,w in ipairs(waves) do
    local values={};for _,v in ipairs(w) do values[#values+1]=type(v)=='string' and string.format('%q',v) or tostring(v) end
    rows[#rows+1]='['..table.concat(values,',')..']'
   end
   print('{"id":'..id..',"length":'..c.t3..',"waves":['..table.concat(rows,',')..']}')
  end
 end
end
