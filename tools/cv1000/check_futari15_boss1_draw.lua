-- 用原程序的独立绘图请求核对整数坐标、层次、翻转、颜色、叠加层和脚步事件。
local draw=dofile('mod/GAME/th46/boss1_draw.lua')
local art=dofile('mod/GAME/th46/boss1_art.lua')
local function digest(rows)
    local n=0
    for _,row in ipairs(rows)do for _,v in ipairs(row)do n=(n*131+v)%16777213 end end
    return n
end
local function check(reference)
local b,total,feet=reference.initial,0,0
for _,r in ipairs(reference.steps)do
    for i=1,#r[8],2 do b[r[8][i]]=r[8][i+1]end
    local rows,events,randomIndex={},{},0
    draw.update(b,r[3],r[4],r[5],r[6],r[7],function(...)
        local row={...};rows[#rows+1]=row;return row
    end,function(kind,value)
        local id=assert(({stepSound=1,foot=2,stepShake=3})[kind])
        events[#events+1]={id,value or 0};if id==2 then feet=feet+1 end
    end,function(limit)
        assert(limit==1);randomIndex=randomIndex+1;return assert(r[13][randomIndex])
    end)
    local fields={};for _,field in ipairs(draw.outputFields)do fields[#fields+1]=assert(b[field[1]])end
    assert(digest({fields})==r[9],'第 '..r[1]..' 帧 / '..r[2]..' 次绘制的关节或牵引点不符：'..digest({fields})..' / '..r[9])
    assert(#rows==r[12]and digest(rows)==r[10],'第 '..r[1]..' 帧 / '..r[2]..' 次精灵请求不符：'..#rows..' / '..r[12]..'，'..digest(rows)..' / '..r[10])
    assert(digest(events)==r[11]and randomIndex==#r[13],'脚步事件或随机调用不符')
    for _,row in ipairs(rows)do
        local rect=assert(art.sprites[row[1]],'图集缺少原版裁片 '..row[1])
        assert(rect[1]>0 and rect[2]>0 and rect[1]+rect[3]<art.width and rect[2]+rect[4]<art.height)
    end
    total=total+#rows
end
assert(total==reference.sprites)
print(('Futari 1.5 关底 %d 次绘图、%d 个精灵、六碰撞锚点与 %d 次脚步通过'):format(reference.states,total,feet))
end
local fixture=os.getenv('FUTARI15_DRAW_FIXTURE')
if fixture then check(dofile(fixture))
else
    check(dofile('tools/cv1000/fixtures/futari15_boss1_draw_entry.lua'))
    check(dofile('tools/cv1000/fixtures/futari15_boss1_draw.lua'))
end
