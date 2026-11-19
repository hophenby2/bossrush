local M=EISlib.Player
function M.loadRes(res_name, res_path)
	-- 行走图加载
	LoadImageGroupFromFile(res_name..'_normal', res_path .. 'normal.png', true, 4, 3)
	LoadImageGroupFromFile(res_name..'_left', res_path .. 'left.png', true, 4, 3)
	LoadImageGroupFromFile(res_name..'_right', res_path .. 'right.png', true, 4, 3)
	
	local equip_names = {} -- 存放装备纹理名的字符串表
	
	-- 1主炮
	LoadTexture(res_name .. "_bullets", res_path .. "bullets.png") -- 包含了自机所有子弹类别和使魔
	-- 主枪弹幕素材
	LoadImage(res_name .. "_main_bullet", res_name .. "_bullets",
			0, 0, 128, 128)
	-- 消失特效
	LoadAniFromFile(res_name .. "_main_bullet_ef", res_path .. "main_eff.png",
			true, 4, 2, 1)
	-- 资源名数据
	table.insert(equip_names, {
		res_name .. "_main_bullet",
		res_name .. "_main_bullet_ef",
	})
	
	-- 2直线、3诱导、4散枪
	local types = {
		"straight",
		"trail",
		"spread",
	}
	for i, name in ipairs(types) do
		-- 副枪素材
		LoadImage(res_name .. "_" .. name .. "_bullet", res_name .. "_bullets",
				128 * i, 0, 128, 128)
		-- 副枪使魔
		LoadImage(res_name .. "_" .. name .. "_support", res_name .. "_bullets",
				128 * i, 128, 128, 128)
		-- 副枪击中特效
		LoadAniFromFile(res_name .. "_" .. name .. "_bullet_ef", res_path .. name .. "_eff.png",
				true, 4, 2, 1)
		-- 资源名数据
		table.insert(equip_names, {
			res_name .. "_" .. name .. "_bullet", -- 子机子弹
			res_name .. "_" .. name .. "_support", -- 子机
			res_name .. "_" .. name .. "_bullet_ef", -- 子弹消失特效
		})
	end
	
	-- 5激光
	LoadTexture(res_name .. "_laser_eff", res_path .. "laser_eff.png")
	-- 激光体（注意是tex）
	LoadTexture(res_name .. "_laser", res_path .. "laser.png")
	-- 激光发射源
	LoadImage(res_name .. "_laser_source", res_name .. "_laser_eff", 0, 0, 128, 128)
	-- 激光击中特效
	LoadImage(res_name .. "_laser_hiteff", res_name .. "_laser_eff", 128, 0, 128, 128)
	-- 资源名数据
	table.insert(equip_names, {
		res_name.."_laser", -- 激光体（注意是tex）
		res_name.."_laser_source", -- 激光发射源
		res_name.."_laser_hiteff", -- 激光击中特效
	})
	
	return equip_names
end

function M.makeResourcesName(res_name)
	local equip_names = {} --存放装备纹理名的字符串表
	-- 1主炮
	table.insert(equip_names, {
		res_name .. "_main_bullet",
		res_name .. "_main_bullet_ef",
	})
	-- 2直线、3诱导、4散枪
	local types = {
		"straight",
		"trail",
		"spread",
	}
	for _, name in ipairs(types) do
		table.insert(equip_names, {
			res_name .. "_" .. name .. "_bullet", -- 子机子弹
			res_name .. "_" .. name .. "_support", -- 子机
			res_name .. "_" .. name .. "_bullet_ef", -- 子弹消失特效
		})
	end
	-- 5激光
	table.insert(equip_names, {
		res_name.."_laser", -- 激光体（注意是tex）
		res_name.."_laser_source", -- 激光发射源
		res_name.."_laser_hiteff", -- 激光击中特效
	})
	return equip_names
end

--endregion
----------------------------------------
