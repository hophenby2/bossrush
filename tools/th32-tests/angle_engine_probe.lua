-- 安装到隔离的Windows验证副本，记录真实构造出的TH32弹体，不修改发弹参数。
return function(T)
    local install=T.install
    function T.install()
        install()
        local rows={}
        local previous_trace=TH32_NATIVE_TRACE
        local current_fire
        TH32_NATIVE_TRACE=function(b,kind,...)
            if previous_trace then previous_trace(b,kind,...) end
            if kind=='fire' then
                local p={...}
                current_fire={owner=b.th06,full=(p[1]=='random' or p[1]=='random_angle')
                    and math.abs(p[8]-3.1415927410125732)<1e-6
                    and math.abs(p[9]+3.1415927410125732)<1e-6}
            end
        end
        local original_new=New
        New=function(cls,...)
            local o=original_new(cls,...)
            if o.th06_sprite and current_fire and current_fire.full and current_fire.owner==o.th06_owner then
                local owner=o.th06_owner.actors[1]
                -- Serialize把数字卡号键当作稀疏数组；统计映射必须使用字符串键。
                local id=tostring(owner.meta.id)
                local row=rows[id]
                if not row then
                    row={count=0,left=0,right=0,up=0,down=0,octants={0,0,0,0,0,0,0,0},samples={}}
                    rows[id]=row
                end
                row.count=row.count+1
                if o.vx<0 then row.left=row.left+1 else row.right=row.right+1 end
                if o.vy<0 then row.down=row.down+1 else row.up=row.up+1 end
                local index=math.min(8,math.floor((o.th06_angle+math.pi)/(2*math.pi)*8)+1)
                index=math.max(1,index)
                row.octants[index]=row.octants[index]+1
                if #row.samples<24 then row.samples[#row.samples+1]={o.x,o.y,o.th06_angle,o.vx,o.vy} end
            end
            return o
        end
        lstg.New=New
        local original_exit=GameExit
        GameExit=function()
            local f=assert(io.open('th32-angle-probe.json','w'))
            f:write(Serialize(rows));f:close()
            original_exit()
        end
    end
end
