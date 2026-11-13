function misc.RenderTile(tex, blend, color, x, y, rot, hscale, vscale, u, v, uvrot, uvhscale, uvvscale)
	--设置采样方式
	if AndroidPlatform then SetTextureSamplerState(tex,"linear+wrap")
	else SetTextureSamplerState("address","wrap") end
	--计算顶点坐标
	local texw, texh = GetTextureSize(tex)
	local texw2, texh2 = texw / 2, texh / 2
	local texpos = {
		x = { -texw2 * hscale, texw2 * hscale, texw2 * hscale, -texw2 * hscale },
		y = { texh2 * vscale, texh2 * vscale, -texh2 * vscale, -texh2 * vscale },
	}
	for s = 1, 4 do
		texpos.x[s], texpos.y[s] = texpos.x[s] * cos(rot) - texpos.y[s] * sin(rot), texpos.x[s] * sin(rot) + texpos.y[s] * cos(rot)
		texpos.x[s], texpos.y[s] = texpos.x[s] + x, texpos.y[s] + y
	end
	--计算uv坐标
	local uvpos = {
		u = { -texw2 * uvhscale, texw2 * uvhscale, texw2 * uvhscale, -texw2 * uvhscale },
		v = { -texh2 * uvvscale, -texh2 * uvvscale, texh2 * uvvscale, texh2 * uvvscale },
	}
	for s = 1, 4 do
		uvpos.u[s], uvpos.v[s] = uvpos.u[s] * cos(uvrot) - uvpos.v[s] * sin(uvrot), uvpos.u[s] * sin(uvrot) + uvpos.v[s] * cos(uvrot)
		uvpos.u[s], uvpos.v[s] = uvpos.u[s] + texw2 - u, uvpos.v[s] + texh2 + v--uv坐标中心点在左上角
	end
	--填充数据
	local vertex = {
		{ texpos.x[1], texpos.y[1], 0.5, uvpos.u[1], uvpos.v[1], },
		{ texpos.x[2], texpos.y[2], 0.5, uvpos.u[2], uvpos.v[2], },
		{ texpos.x[3], texpos.y[3], 0.5, uvpos.u[3], uvpos.v[3], },
		{ texpos.x[4], texpos.y[4], 0.5, uvpos.u[4], uvpos.v[4], },
	}
	if type(color) == "table" then
		for s = 1, 4 do
			vertex[s][6] = color[s]
		end
	else
		for s = 1, 4 do
			vertex[s][6] = color
		end
	end
	--渲染
	RenderTexture(tex, blend, vertex[1], vertex[2], vertex[3], vertex[4])
	--恢复采样方式
	if AndroidPlatform then SetTextureSamplerState(tex,"linear+clamp")
	else SetTextureSamplerState("address","clamp") end
end

---纹理平铺符卡背景
---@param tex string @texture res
---@param blend string @blendmode
---@param color lstg.Color
---@param u number
---@param v number
---@param uvrot number
---@param uvhscale number
---@param uvvscale number
function misc.RnderTileSCBG(tex, blend, color, u, v, uvrot, uvhscale, uvvscale)
	local world = lstg.world
	local worldw, worldh = world.r - world.l, world.t - world.b
	local w, h = GetTextureSize(tex)
	local scale = math.max(worldw / w, worldh / h)
	misc.RenderTile(tex, blend, color,
			0, 0, 0, scale, scale,
			u, v, uvrot, scale / uvhscale, scale / uvvscale)
end


function rendercircle(x, y, r, point)
	--player death effect
	SetImageState("white", "add+sub",
			Color(96,255,255,255)
	)
	local ang = 360 / (2 * point)
	for angle = 360 / point, 360, 360 / point do
		local x1, y1 = x + r * cos(angle + ang), y + r * sin(angle + ang)
		local x2, y2 = x + r * cos(angle - ang), y + r * sin(angle - ang)
		Render4V('white', x, y, 0.5,
				x, y, 0.5,
				x1, y1, 0.5,
				x2, y2, 0.5)
	end
	SetImageState("white", "", Color(255, 255, 255, 255))
end

function sp.misc.RenderRing(img, x, y, outer, inner, segments, rotation, length, z)
	segments, rotation, length, z = segments or 1, rotation or 0, length or 360, z or 0.5
	local step = length / segments
	for i = 1, segments do
		local a, b = rotation + (i - 1) * step, rotation + i * step
		local ca, sa, cb, sb = cos(a), sin(a), cos(b), sin(b)
		Render4V(img, x + outer * ca, y + outer * sa, z,
			x + outer * cb, y + outer * sb, z,
			x + inner * cb, y + inner * sb, z,
			x + inner * ca, y + inner * sa, z)
	end
end
