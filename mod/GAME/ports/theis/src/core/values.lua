ex = {}

function ex.SmoothSetValueTo(valname, y, t, mode, setter, starttime, vmode)
	if starttime then
		task.Wait(starttime)
	end
	local self = task.GetSelf()
	---@type fun():number
	local getter
	if valname == "_speed" then
        getter = function() return GetV(self) end
        setter = setter or function(value)
            local _, angle = GetV(self)
            SetV(self,value,angle)
        end
    elseif type(valname) == "function" then
		getter = valname
	else
		getter = function()
			if IsValid(self) then
				return self[valname]
			else
				return 0
			end
		end
	end
	setter = setter or function(v)
		if IsValid(self) then
			self[valname] = v
		end
	end
	task.SetValueTo(t, mode, vmode, y, getter, setter)
end
