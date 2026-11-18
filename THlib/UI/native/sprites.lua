-- 横纵屏共用同一组原版纹理、数字和坐标；这里只转换从上往下的原作 Y 坐标。
return function(level)
    local floor,min=math.floor,math.min
    local code=level+2
    local base='Resources/th'..code..'/hud/'
    local prefix='nativehud/'..code..'/'
    local width,height=640,480
    if code==38 then width,height=1280,960 elseif code==39 then width,height=1920,1080 end
    local function texture(name)
        local key=prefix..name
        if not CheckRes('tex',key) then LoadTexture(key,base..name..'.png') end
        return key
    end
    local function blit(tex,x,y,u,v,w,h,sw,sh,color)
        local l,r,t,b=x,x+(sw or w),height-y,height-y-(sh or h)
        local c=color or Color(0xffffffff)
        RenderTexture(tex,'',{l,t,.5,u,v,c},{r,t,.5,u+w,v,c},{r,b,.5,u+w,v+h,c},{l,b,.5,u,v+h,c})
    end
    local bg=texture('single')
    local h={frame=function() blit(bg,0,0,0,0,width,height) end}
    local s,t,score,high,extra
    function h.update(state)
        s,t=state,stage.current_stage.timer
        score=math.max(0,math.floor(lstg.var.score or 0));high=math.max(score,lstg.tmpvar.hiscore or 0)
        extra=ui.NativeHUD.isExtra()
    end
    if code==37 or code==39 then
        local num,rank,stock=texture('number'),texture('dicolty'),texture('numlogo')
        local boss=texture('bosslist')
        local classic=code==37
        if not classic then
            local edge,border=texture('edgetrim'),texture('screenborder')
            local background=h.frame
            h.frame=function()
                background()
                blit(border,0,0,0,0,width,height)
                blit(edge,0,0,0,0,width,height)
            end
        end
        local function number(value,x,y)
            local str=tostring(value)
            local w,h,z=classic and 12 or 27,classic and 16 or 39,classic and 1 or .9
            if not classic then x=x-#str*w*z end
            for i=1,#str do
                local ch=str:sub(i,i)
                if ch~=' ' then
                    local n=tonumber(ch) or (ch=='.' and 10 or 11)
                    blit(num,x+(i-1)*w*z,y,n*w,0,w,h,w*z,h*z)
                end
            end
        end
        local function inventory(n,life)
            local y=classic and (life and 91 or 116) or (life and 178 or 233)
            local full=math.min(10,math.floor(math.max(0,n)/5))
            local part=full<10 and n%5 or 0
            local x=classic and 492 or 1366
            local step=classic and 13 or 27
            local frame=math.floor(t/6)%7*70
            local row=life and 70 or 140
            for i=0,full-1 do
                if classic then
                    blit(stock,x+i*step,y,82,1,16,18,nil,nil,life and Color(255,255,153,255) or Color(255,0,230,102))
                else blit(stock,x+i*step,y,frame,row,70,70) end
            end
            if part==0 then return end
            x=x+full*step
            if classic then blit(stock,x,y,(part-1)*20+2,1,16,18)
            else
                local offset=({50,45,39,32})[part]
                blit(stock,x,y,frame,0,70,70,nil,nil,Color(102,255,255,255))
                blit(stock,x,y+offset,frame,row+offset,70,70-offset)
                blit(stock,x,y+7,(part-1)*70,210,70,70)
            end
        end
        function h.draw()
            local index=extra and 4 or 3
            local maxBlue=s.pointrate or (extra and 300000 or 200000)+(classic and (lstg.var.graze or 0)*10 or 0)
            if classic then
                blit(rank,474,13,0,index*17,118,17)
                number(('%011d'):format(high),492,42);number(('%011d'):format(score),492,63)
                number(('%.2f/4.00'):format(s.power/100),516,150)
                number(('%7d'):format(maxBlue),540,173);number(('%6d'):format(lstg.var.graze or 0),552,196)
            else
                blit(rank,1215,12,0,index*70,440,70)
                number(('%011d'):format(high),1660,90);number(('%011d'):format(score),1660,140)
                number(maxBlue,1660,335);number(lstg.var.graze or 0,1660,383)
            end
            inventory(s.life,true);inventory(s.bombs,false)
        end
        function h.boss(b,hp,time)
            local cd=('%02d'):format(min(99,floor(time)))
            local segments=math.min(7,math.max(0,(b.sc_left or 1)-1))
            if classic then
                blit(boss,31,12,0,350,385,70)
                for j=0,segments-1 do blit(boss,31,12,0,420+70*j,385,70) end
                blit(boss,45,20,b.time_sc and 42 or 0,0,42,8,354*hp,8)
                for i=1,2 do blit(boss,67+(i-1)*13,29,tonumber(cd:sub(i,i))*15,9,15,20) end
                blit(boss,224+b.x-45,457,280,15,89,25)
            else
                local function sprite(x,y,u,v,w,h,z)
                    blit(boss,240+x*1.5,y*1.5,u,v,w,h,w*z*1.5,h*z*1.5)
                end
                sprite(40,22,0,72,901,127,.66)
                if hp>0 then sprite(69.04,27.94,0,b.time_sc and 16 or 32,math.max(1,floor(812*hp)),16,.66) end
                sprite(65.74,25.3,0,48,821,24,.66)
                for j=0,segments-1 do sprite(40,22,0,199+127*j,290,127,.66) end
                for i=1,2 do sprite(119+(i-1)*14,42,tonumber(cd:sub(i,i))*26,1088,26,34,.66) end
                blit(boss,744+b.x*2.25-89,1038,778,1088,178,42)
            end
        end
        return h
    end
    local data=dofile('mod/GAME/th'..code..'/hud_data.lua')
    local tex=texture('panel')
    local function image(name,x,y,sw,sh,anchor)
        local r=data.sprites[name]
        local w,h=sw or r[3],sh or r[4]
        if anchor then x,y=x-r[5]*w/r[3],y-r[6]*h/r[4] end
        blit(tex,x,y,r[1],r[2],r[3],r[4],w,h)
    end
    if code==40 then
        local labels={{'最高得分',428,44},{'得分',428,67},{'剩余人数',428,99},{'SC',428,125},
            {'灵力',442,188},{'最大得点',442,214},{'擦弹',442,240}}
        local function num(font,str,x,y)
            local _,punct=str:gsub('[.,]','')
            x=x+punct*8+5
            for ch in str:gmatch('.') do
                local small=ch=='.' or ch==','
                if small then x=x-5 end
                if ch~=' ' then image(font..'Num_'..ch,x,y+9,nil,nil,true) end
                x=x+13-(small and 3 or 0)
            end
        end
        local function scoreText(v)
            return (tostring(10000000000+v):reverse():gsub('(%d%d%d)','%1,'):reverse():sub(2))
        end
        local function slots(stock,n,chip,threshold,y)
            local count=math.min(8,math.max(0,n))
            for i=0,7 do
                local img=i<count and stock or stock..'0d'
                local part=math.floor(chip*(stock=='Life' and 5 or 4)/threshold)
                if i==count and part>0 then img=stock..('%02d'):format(part-1) end
                image(img,504+i*16,y,16,16)
            end
        end
        local function field()
            local mark=({red='B',blue='A',green='C'})[s.enchantment or s.lastStarColor or 'green']
            local r=data.sprites['border'..mark..'2']
            local x,y=66,404
            image('border'..mark..'1',x,y,nil,nil,true)
            local f=math.max(1,math.floor(r[4]*math.min(1,(s.star or 0)/3000)))
            blit(tex,x-r[5],y-r[6]+r[4]-f,r[1],r[2]+r[4]-f,r[3],f)
            image('border'..mark..'0',x,y,nil,nil,true)
        end
        h.field=field
        function h.boss(b,hp,time)
            local bar=data.sprites.HP_Line1
            if hp>0 then blit(tex,246-bar[3]/2,29-bar[4]/2,bar[1],bar[2],bar[3]*hp,bar[4]) end
            image('HP_Line2',246,29,nil,nil,true)
            for i=0,math.min(9,math.max(0,(b.sc_left or 1)-1))-1 do
                image('表示符卡数量的星星（单个）',101+i%5*16,38+math.floor(i/5)*16,16,16)
            end
            image('球球',61,40,nil,nil,true)
            local str=('%.1f'):format(time)
            local prefix,dy,delta,offset='tsnum',3,9,0
            for i=#str,1,-1 do
                local ch=str:sub(i,i)
                if ch=='.' then prefix,delta,offset='tnum',10,4 end
                image(prefix..ch,79-(22-delta)*(#str-i)+offset,40+dy,nil,nil,true)
                if ch=='.' then prefix,dy,delta,offset='tnum',0,3,20 end
            end
        end
        function h.draw()
            image(extra and 'Extra' or 'Lunatic',530,24,nil,nil,true)
            for i,row in ipairs(labels) do
                image(row[1],row[2],row[3])
                if i<=6 then image(('InterfaceLine%02d'):format(i-1),488,row[3]+((i==3 or i==4) and 22 or 16)) end
            end
            num('HiScore',scoreText(high),468,47);num('Score',scoreText(score),468,70)
            num('Red',('%11s'):format(('%.2f/4.00'):format(s.power/100)),492,188)
            num('Blue',('%11d'):format(s.pointrate or 100000),492,214)
            num('Graze',('%11d'):format(lstg.var.graze or 0),492,240)
            local threshold=({3,5,8,10,12,15,18,20,22})[math.min(9,1+(s.extends or 0))]
            slots('Life',s.life,s.lifeChip,threshold,101);slots('Bomb',s.bombs,s.bombChip,4,127)
            num('Shard',tostring(s.lifeChip)..'/'..threshold,586,112)
        end
        return h
    end
    local nodes=data.nodes
    local function node(group,key,sprite,sw)
        local o=nodes[group][tostring(key)]
        if o then image(sprite or o[3],o[1],o[2],sw,nil,true) end
    end
    local function digits(group,value,first,last,font)
        value=math.floor(math.max(0,value))
        for i=first,last do
            node(group,i,'number_'..(font+value%10))
            value=math.floor(value/10)
            if value==0 then break end
        end
    end
    local function field()
        local layers=NativePlayers.barriers(s)
        local group='system'
        node(group,'system_kuang')
        node(group,'system_baoshi')
        local amount=s.barrier%100000/100000
        node(group,'system_tiao',nil,math.max(.01,data.sprites.system_35[3]*amount))
        node(group,'system_ceng')
        for i=0,2 do node(group,'system_'..(40+i),'system_'..(i<layers and 41 or 40)) end
        local pct=math.floor(amount*100)
        node(group,'system_0');node(group,'system_1','system_'..(17+pct%10))
        if pct>=10 then node(group,'system_2','system_'..(17+math.floor(pct/10))) end
    end
    h.field=field
    function h.boss(b,hp,time)
        local nodes=data.nodes.boss
        local function health(key)
            local o=nodes[key]
            if not o then return end
            local r=data.sprites[o[3]]
            local y=o[2]+(key=='bosslife' and 159 or 0)
            if hp>0 then blit(tex,o[1]-r[5],y-r[6],r[1],r[2],r[3]*hp,r[4]) end
        end
        health('bosslife');health('bosslife2')
        local seconds=('%02d'):format(math.min(99,floor(time)))
        for i=1,2 do image('time_daojishi_'..tonumber(seconds:sub(i,i)),99+(i-1)*26,63,nil,nil,true) end
    end
    function h.draw()
        image(extra and 'rank_4' or 'rank_0',1056,47,nil,nil,true)
        for _,row in ipairs({{'score_max',high},{'score',score}}) do
            node(row[1],'xuguancishu','number_'..math.min(9,lstg.var.coun_num or 0))
            local value=math.floor(row[2]/10)
            if value>0 then digits(row[1],value,1,9,0) end
            for k=0,2 do if row[2]>=1000^(k+1) then node(row[1],'dian'..k) end end
        end
        for i=0,7 do node('life',i,i+1<s.life and 'lighted' or 'dark') end
        local threshold=NativePlayers.lifeThreshold(s)
        if s.fragments>=10 then node('bomb','next_1','next_'..math.floor(s.fragments/10)) end
        node('bomb','next_0','next_'..s.fragments%10);node('bomb','next_gang')
        node('bomb','next_2','next_'..(threshold>=10 and math.floor(threshold/10) or threshold))
        if threshold>=10 then node('bomb','next_3','next_'..threshold%10) end
        digits('dedian',s.pointValue or 10000,0,6,11);node('dedian','dian')
        digits('cadan',lstg.var.graze or 0,0,5,22)
        if (lstg.var.graze or 0)>=1000 then node('cadan','dian') end
        local ticks=s.hudClock or (extra and 86400 or 172800)
        local minutes=math.floor(ticks/7200);local seconds=math.floor(ticks/120)%60
        local frac=math.floor(ticks%120/2)
        local values={frac%10,math.floor(frac/10),10,seconds%10,math.floor(seconds/10),10,minutes%10,math.floor(minutes/10)}
        for i=0,7 do if i<7 or minutes>=10 then node('daojishi',i,'time_daojishi_'..values[i+1]) end end
    end
    return h
end
