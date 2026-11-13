---=====================================
---东方祈华梦激光素材
---=====================================

local path= "res/bullet/"

----------------------------------------
---res

LoadLaserTextureFromFile(path.."laser1.png", 256, 256, 64, 128, 64,0.5,8)
LoadLaserTextureFromFile(path.."laser2.png", 256, 256, 5, 236, 15,0.5,8)
LoadLaserTextureFromFile(path.."laser3.png", 256, 256, 127, 1, 128,0.5,6)
LoadLaserTextureFromFile(path.."laser4.png", 256, 256, 1, 254, 1,0.5,6)

lstg.ResourceSet.Find("THlib.laser"):AddTexture("laser_bent0",path.."laser_bent.png",false)
Add_bentlaser_texture_16(4, "laser_bent0", 256, 256)
Add_bentlaser_envelope(4, 0.0, 0.5, 0.8, 4.0)

--[[
for i,v in ipairs({2,3,4,5,6,7,8,9,1}) do
	LoadTexture("laser_bent"..i, path.."thunder_laser"..v..".png", false)
end

Add_bentlaser_thunder_texture_single(0, "laser_bent9",4)
Add_bentlaser_envelope(0, 0.0, 0.3, 1.0, 4.0)
for i=1,8 do
	Add_bentlaser_thunder_texture_single(10+i, "laser_bent"..i,4)
	Add_bentlaser_envelope(i, 0.0, 0.3, 1.0, 4.0)
end
--]]
