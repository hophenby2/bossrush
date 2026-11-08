-- 右侧状态统一采用现有擦弹／资金力的分隔线、左标签与右数值布局。
return function(self,label,value,x1,x2,y,alpha,rgb,scale)
    rgb=rgb or {173,173,173};scale=scale or .8
    SetImageState('line_7','',alpha,255,255,255)
    RenderRect('line_7',x1,x2,y+4,y-4)
    local color=Color(alpha,rgb[1],rgb[2],rgb[3])
    self:RenderText('title',label..'：',x1,y,scale,color,'left','bottom')
    self:RenderText('title',tostring(value),x2,y,scale,color,'right','bottom')
end
