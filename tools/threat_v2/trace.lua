-- 只采集分析轨迹，不修改卡片参数；对象弹、不可消弹和直线光一起纳入。
-- 使用 check_stage 的实际逐帧回调推进加速 / 转向 / 停顿，避免把 vx=0 的手算弹当静止。
local ffi=require('ffi')
local path,frames,folder,wanted=assert(arg[1]),tonumber(arg[2]) or 1800,assert(arg[3]),arg[4] or ''
local selected={};for id in wanted:gmatch('%d+') do selected[tonumber(id)]=true end
local sample=tonumber(os.getenv('THREAT_SAMPLE')) or 2
local file,meta,ids,serial,current,recordCount,unknown,objectsCount,bulletsCount,laserCount,lastFrame
local names={};local buffer=ffi.new('float[?]',200000)
local function radius(o)
    if o.a and o.b and math.max(o.a,o.b)>0 then return math.max(o.a,o.b),false end
    if o.r then return o.r,false end
    local style=o.imgclass or o.style
    style=style and (style.collision_style or style)
    local r=style and STYLE_RADIUS[names[style] or '']
    return r or 4,r==nil
end
_G.STAGE_HOOK={quiet=true,
    select_card=function(_,e) return selected[e.card_id]==true end,
    frame_limit=function(_,e,n) return math.min(n,math.floor(e.card.t3*60)) end,
    on_card=function(index,e)
        current=e;recordCount=0;unknown=0;objectsCount=0;bulletsCount=0;laserCount=0
        lastFrame=0
        ids=setmetatable({},{__mode='k'});serial=0
        for name,value in pairs(_G) do if type(value)=='table' and STYLE_RADIUS[name] then names[value]=name end end
        file=assert(io.open(folder..'/'..e.card_id..'.f32','wb'))
        meta=assert(io.open(folder..'/'..e.card_id..'.meta.tsv','w'))
        meta:write('id\t'..e.card_id..'\nindex\t'..index..'\nname\t'..e.name..'\nspell\t'..tostring(e.card.is_sc)..'\n')
        meta:write('seconds\t'..e.card.t3..'\nsample\t'..sample..'\nseed_base\t'..(os.getenv('STAGE_SEED') or 20260916)..'\n')
    end,
    set_player=function() player.x,player.y=0,-176;return true end,
    on_frame=function(_,f,bullets,objects)
        if f%sample~=0 then return end
        local n=0
        local function emit(o,object)
            if o._live==false or o.colli==false or (o.group~=1 and o.group~=5 and o.group~=10) then return end
            local x,y,a,b,angle,kind=o.x,o.y,0,0,o.rot or 0,0
            if o.IsLaser or o.group==10 then
                if (o.alpha or 0)<.999 then return end
                local length=(o.l1 or 0)+(o.l2 or 0)+(o.l3 or 0)
                if length<=0 or (o.w or 0)<=0 then return end
                local width=o.w
                -- TH35 的临时判定缩到中间 80%，随后会恢复显示用 l2/w。
                if o.t10_len then
                    length=o.t10_len*.8
                    width=o.w0*.5
                    if o.w0>=32 then width=o.w0-(o.w0+16)*(o.t10_wait and 1/3 or .5) end
                end
                a,b,kind=length*.5,width*.5,1
                x=x+math.cos(math.rad(angle))*(o.t10_len and o.t10_len*.5 or length*.5)
                y=y+math.sin(math.rad(angle))*(o.t10_len and o.t10_len*.5 or length*.5)
                laserCount=laserCount+1
            else
                local fallback;a,fallback=radius(o);b=a
                if fallback then unknown=unknown+1 end
            end
            if not ids[o] then serial=serial+1;ids[o]=serial end
            local k=n*10
            assert(k+10<200000,'单帧对象过多')
            buffer[k],buffer[k+1],buffer[k+2],buffer[k+3]=f,ids[o],x,y
            buffer[k+4],buffer[k+5],buffer[k+6],buffer[k+7]=a,b,angle,kind
            buffer[k+8],buffer[k+9]=o.group,o._index or o.t10_color or 0
            n=n+1
            if object then objectsCount=objectsCount+1 else bulletsCount=bulletsCount+1 end
        end
        for _,o in ipairs(bullets) do emit(o,false) end
        for _,o in ipairs(objects) do emit(o,true) end
        file:write(ffi.string(buffer,n*40));recordCount=recordCount+n
        lastFrame=f
    end,
    on_error=function(_,message) error(message,0) end,
    on_card_end=function()
        file:close();meta:write('last_frame\t'..lastFrame..'\nrecords\t'..recordCount..'\nunknown_radius\t'..unknown..'\nobject_records\t'..objectsCount..'\nbullet_records\t'..bulletsCount..'\nlaser_records\t'..laserCount..'\n');meta:close()
    end,
}
arg[1],arg[2],arg[3]=path,tostring(frames),nil
dofile('tools/check_stage.lua')
