---=====================================
---复杂的渲染方法
---author:Xiliusha
---email:Xiliusha@outlook.com
---=====================================

---@type EISlib
local lib=EISlib

---@class EISlib.Render
local M={}

---@type EISlib.Render
lib.Render=M

----------------------------------------
---render function

---以极坐标的方式将纹理渲染成一个环
---@param tex string @texture res name
---@param blend string @blend mode
---@param color lstg.Color
---@param x number
---@param y number
---@param r1 number
---@param r2 number
---@param rot number @ring rotate
---@param div number @integer, division count
---@param rep number @integer, repeat count
---@param t number @( 0 ~ 1 ), lerp
function M.RenderTexturePolarRing(tex, blend, color, x, y, r1, r2, rot, div, rep, t)
	local w, h = GetTextureSize(tex)
	local n = div * rep--分成多少扇渲染，总扇数为分割数*重复数
	local perunit = h / div--但是v坐标的步进还是除以分割数
	local da = 360 / n--每个扇的圆心角
	local r12 = r1 + (r2 - r1) * t--中间半径
	local as = rot--起始渲染角度
	for i = 0, (rep - 1) do
		for j = 0, (div - 1) do
			local a1, a2 = as, as - da--顶点朝向
			local u0, u1, u2 = 0, w - w * t, w--u坐标位置
			local v1, v2 = j * perunit, (j + 1) * perunit--v坐标位置
			--内半部分
			RenderTexture(tex, blend,
					{ x + r1 * cos(a1), y + r1 * sin(a1), 0.5, u1, v1, color },
					{ x + r12 * cos(a1), y + r12 * sin(a1), 0.5, u2, v1, color },
					{ x + r12 * cos(a2), y + r12 * sin(a2), 0.5, u2, v2, color },
					{ x + r1 * cos(a2), y + r1 * sin(a2), 0.5, u1, v2, color })
			--外半部分
			RenderTexture(tex, blend,
					{ x + r12 * cos(a1), y + r12 * sin(a1), 0.5, u0, v1, color },
					{ x + r2 * cos(a1), y + r2 * sin(a1), 0.5, u1, v1, color },
					{ x + r2 * cos(a2), y + r2 * sin(a2), 0.5, u1, v2, color },
					{ x + r12 * cos(a2), y + r12 * sin(a2), 0.5, u0, v2, color })
			as = as - da
		end
	end
end

function M.RenderImageGroupRingV(imgs,div,blend,color,x,y,r1,r2,rot,rep,rev)
	local img={}
	for i=1,div do
		img[i]=imgs..i
		SetImageState(img[i],blend,color)
	end
	local n=div*rep
	local as=rot
	local da=360/n
	if rev then
		for _=1,rep do
			for i=1,div do
				local a1,a2=as,as+da
				local _sin1, _cos1 = sin(a1), cos(a1)
				local _sin2, _cos2 = sin(a2), cos(a2)
				Render4V(img[i],
						x+r2*_cos1,y+r2*_sin1,0.5,
						x+r1*_cos1,y+r1*_sin1,0.5,
						x+r1*_cos2,y+r1*_sin2,0.5,
						x+r2*_cos2,y+r2*_sin2,0.5)
				as=as+da
			end
		end
	else
		for _=1,rep do
			for i=1,div do
				local a1,a2=as,as-da
				local _sin1, _cos1 = sin(a1), cos(a1)
				local _sin2, _cos2 = sin(a2), cos(a2)
				Render4V(img[i],
						x+r1*_cos1,y+r1*_sin1,0.5,
						x+r2*_cos1,y+r2*_sin1,0.5,
						x+r2*_cos2,y+r2*_sin2,0.5,
						x+r1*_cos2,y+r1*_sin2,0.5)
				as=as-da
			end
		end
	end
end

function M.RenderImageGroupRingH(imgs,div,blend,color,x,y,r1,r2,rot,rep,rev)
	local img={}
	for i=1,div do
		img[i]=imgs..i
		SetImageState(img[i],blend,color)
	end
	local n=div*rep
	local as=rot
	local da=360/n
	if rev then
		for _=1,rep do
			for i=1,div do
				local a1,a2=as,as+da
				local _sin1, _cos1 = sin(a1), cos(a1)
				local _sin2, _cos2 = sin(a2), cos(a2)
				Render4V(img[i],
						x+r1*_cos1,y+r1*_sin1,0.5,
						x+r1*_cos2,y+r1*_sin2,0.5,
						x+r2*_cos2,y+r2*_sin2,0.5,
						x+r2*_cos1,y+r2*_sin1,0.5)
				as=as+da
			end
		end
	else
		for _=1,rep do
			for i=1,div do
				local a1,a2=as,as-da
				local _sin1, _cos1 = sin(a1), cos(a1)
				local _sin2, _cos2 = sin(a2), cos(a2)
				Render4V(img[i],
						x+r2*_cos1,y+r2*_sin1,0.5,
						x+r2*_cos2,y+r2*_sin2,0.5,
						x+r1*_cos2,y+r1*_sin2,0.5,
						x+r1*_cos1,y+r1*_sin1,0.5)
				as=as-da
			end
		end
	end
end
