-- 共用原「要高考了姐妹们-Special」题库与四区随机排布，题目及答案保持不变。
local Q={TIME=500}
Q.questions={
    {"已知lg x+lg y=2,则x+y的最小值为？", "20", "2", "40", "-20"},
    {"已知(x-3)²+(y-4)²=9,则x²+y²的最大值为？", "64", "2", "4", "32"},
    {"已知z=2-i,则5/z为？", "2+i", "(10+5i)/3", "2.5+5i", "2-i"},
    {"已知tanx=3,则(sin2x+cos2x+1)/2=?", "2/5", "6/5", "5/6", "1/5"},
    {"已知y=f(x)的图像在点M(0,f(0))处的切线方程为y=-2x,\n则f(0)+f'(0)=?", "-2", "0", "2", "1"},
    {"已知向量AB=(3,8),A(-1,5),则B的坐标为？", "(2,13)", "(4,3)", "(4,13)", "(2,3)"},
    {"|lgx|=2的两个根的等比中项为？", "±1", "±100", "±10", "±1000"},
    {"已知向量a,b满足条件|a|=8,|b|=3,a·b=12,a与b的夹角为？", "60°", "30°", "45°", "120°"},
}
function Q.shuffle(count,gen)
    local input,output={},{}
    for i=1,count do input[i]=i end
    for i=1,count do output[i]=table.remove(input,gen:Int(1,#input)) end
    return output
end
function Q.new(index,gen)
    local row=assert(Q.questions[index]);local order=Q.shuffle(4,gen)
    local choices={};for i=1,4 do choices[order[i]]=row[i+1] end
    return {index=index,text=row[1],choices=choices,correct=order[1],age=0,choice=1}
end
function Q.answer(x) return math.max(1,math.min(4,3+math.floor(x/96))) end
function Q.fall(n) return n<0.5 and n*1.3 or -1.2*n*n+2.5*n-0.3 end
function Q.wrap(text,width)
    local lines,row,length={},'',0
    for char in text:gmatch('[%z\1-\127\194-\244][\128-\191]*') do
        local size=#char>1 and 1 or 0.5
        if char=='\n' then lines[#lines+1]=row;row='';length=0
        else
            if length+size>width then lines[#lines+1]=row;row='';length=0 end
            row=row..char;length=length+size
        end
    end
    if row~='' then lines[#lines+1]=row end
    return lines
end
GameQuiz=Q
return Q
