--[[
This script is a modification of the soundstreamer package : 
https://github.com/BlueMountainsIO/OnsetLuaScripts/tree/master/soundstreamer
Modified By GalaxHD551
]]--

local StreamedLights = { }

AddEvent("OnPackageStart", function()
	math.randomseed(os.time())
end)

AddEvent("OnPackageStop", function()

	for k, v in pairs(StreamedLights) do
		DestroyObject(k)
	end

	StreamedLights = nil

end)

AddFunctionExport("CreateLight", function (lighttype, x, y, z, rx, ry, rz, color, intensity, streamradius)

	if lighttype == nil or x == nil or y == nil or z == nil then
		return false
	end

	rx = rx or 0.0
	ry = ry or 0.0
	rz = rz or 0.0
	color = color or RGB(255, 255, 255)
	intensity = intensity or 5000.0
	stream_distance = streamradius or 12000.0

	-- Create an object that will help us to attach the light to it
	local lightid = CreateObject(1, x, y, z)

	if lightid == false then
		return false
	end

	SetObjectStreamDistance(lightid, stream_distance)
	SetObjectRotation(lightid, rx, ry, rz)

	local _lightStream = { }
	_lightStream.is_attached = false
	_lightStream.lighttype = lighttype
	_lightStream.color = color
	_lightStream.intensity = intensity
	_lightStream.stream_distance = stream_distance
	_lightStream.attenuation_radius = 1000.0
	_lightStream.shadow = true

	if lighttype == "SPOTLIGHT" then
		_lightStream.outer_cone = 44.0
		_lightStream.inner_cone = 0.0
		_lightStream.source_radius = 0.0
		_lightStream.soft_source_radius = 0.0
		_lightStream.source_lenght = 0.0
		_lightStream.falloff = 0.0
	elseif lighttype == "POINTLIGHT" then
		_lightStream.source_radius = 0.0
		_lightStream.soft_source_radius = 0.0
		_lightStream.source_lenght = 0.0
		_lightStream.falloff = 0.0
	elseif lighttype == "RECTLIGHT" then
		_lightStream.source_width = 64.0
		_lightStream.source_height = 64.0
		_lightStream.barn_door_angle = 88.0
		_lightStream.barn_door_lenght = 20.0
	end

	SetObjectPropertyValue(lightid, "_lightStream", _lightStream)

	StreamedLights[lightid] = _lightStream

	return lightid
end)

AddFunctionExport("SetLightAttached", function(lightid, attachtype, attachid, x, y, z, rx, ry, rz, SocketName)

	if lightid == nil or attachtype == nil or attachid == nil then
		return false
	end

	x = x or 0.0
	y = y or 0.0
	z = z or 0.0
	rx = rx or 0.0
	ry = ry or 0.0
	rz = rz or 0.0
	bone = SocketName or ""

	if StreamedLights[lightid] == nil then
		return false
	end

	if SetObjectAttached(lightid, attachtype, attachid, x, y, z, rx, ry, rz, bone) == false then
		return false
	end

	StreamedLights[lightid].is_attached = true
	StreamedLights[lightid].attach = attachtype
	StreamedLights[lightid].id = attachid
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])

	return true
end)

AddFunctionExport("GetAttachedLights", function(attachtype, id)
	
	if attachtype == nil or id == nil then
		return false
	end

	local lights = { }

	for k, v in pairs(StreamedLights) do
		if v.is_attached == true then
			if v.attach == attachtype and v.id == id then
				table.insert(lights, k)
			end
		end
	end

	return lights
end)

AddFunctionExport("SetLightDetached", function(lightid)
	if lightid == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].is_attached == false then
		return false
	end

	SetObjectDetached(lightid)
	return true
end)

AddFunctionExport("DestroyLight", function(lightid)
	if lightid == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end
	StreamedLights[lightid] = nil
	return DestroyObject(lightid)
end)

AddFunctionExport("GetAllLights", function()
	return StreamedLights
end)

AddFunctionExport("IsValidLight", function(lightid)
	return StreamedLights[lightid] ~= nil
end)

AddFunctionExport("IsAttachedLight", function(lightid)
	if StreamedLights[lightid] == nil then
		return false
	end
	return StreamedLights[lightid].is_attached
end)

AddFunctionExport("SetLightIntensity", function(lightid, intensity)
	if lightid == nil or intensity == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	StreamedLights[lightid].intensity = intensity
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("SetLightColor", function(lightid, color)
	if lightid == nil or color == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end
	StreamedLights[lightid].color = color
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])

	return true
end)

AddFunctionExport("GetLightColor", function(lightid)
	if lightid == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end
	return StreamedLights[lightid].color
end)

AddFunctionExport("SetLightAttenuationRadius", function(lightid, radius)
	if lightid == nil or radius == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	StreamedLights[lightid].attenuation_radius = radius
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightAttenuationRadius", function(lightid)
	if lightid == nil or radius == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end
	return StreamedLights[lightid].attenuation_radius
end)

AddFunctionExport("SetLightIntensityUnits", function(lightid, intensityU)
	if lightid == nil or intensityU == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	StreamedLights[lightid].intensityU = intensityU
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightIntensityUnits", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end
	return StreamedLights[lightid].intensityU
end)

AddFunctionExport("SetLightFalloffExponent", function(lightid, falloff)
	if lightid == nil or falloff == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype == "RECTLIGHT" then
		return false
	end

	StreamedLights[lightid].falloff = falloff
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightFalloffExponent", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype == "RECTLIGHT" then
		return false
	end

	return StreamedLights[lightid].falloff
end)

AddFunctionExport("SetLightSoftSourceRadius", function(lightid, radius)
	if lightid == nil or radius == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype == "RECTLIGHT" then
		return false
	end

	StreamedLights[lightid].soft_source_radius = radius
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightSoftSourceRadius", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype == "RECTLIGHT" then
		return false
	end

	return StreamedLights[lightid].soft_source_radius
end)

AddFunctionExport("SetLightSourceLength", function(lightid, lenght)
	if lightid == nil or lenght == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype == "RECTLIGHT" then
		return false
	end

	StreamedLights[lightid].source_lenght = lenght
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightSourceLength", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype == "RECTLIGHT" then
		return false
	end

	return StreamedLights[lightid].source_lenght
end)

AddFunctionExport("SetLightSourceRadius", function(lightid, radius)
	if lightid == nil or radius == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype == "RECTLIGHT" then
		return false
	end

	StreamedLights[lightid].source_radius = radius
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightSourceRadius", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype == "RECTLIGHT" then
		return false
	end

	return StreamedLights[lightid].source_radius
end)

AddFunctionExport("SetLightCastShadows", function(lightid, bEnable)
	if lightid == nil or bEnable == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	StreamedLights[lightid].shadow = bEnable
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightCastShadows", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	return StreamedLights[lightid].shadow
end)

AddFunctionExport("SetLightOuterConeAngle", function(lightid, degree)
	if lightid == nil or degree == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype ~= "SPOTLIGHT" then
		return false
	end

	StreamedLights[lightid].outer_cone = degree
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightOuterConeAngle", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype ~= "SPOTLIGHT" then
		return false
	end

	return StreamedLights[lightid].outer_cone
end)

AddFunctionExport("SetLightInnerConeAngle", function(lightid, degree)
	if lightid == nil or degree == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype ~= "SPOTLIGHT" then
		return false
	end

	StreamedLights[lightid].inner_cone = degree
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightInnerConeAngle", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype ~= "SPOTLIGHT" then
		return false
	end

	return StreamedLights[lightid].inner_cone
end)

AddFunctionExport("SetLightBarnDoorAngle", function(lightid, degree)
	if lightid == nil or degree == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype ~= "RECTLIGHT" then
		return false
	end

	StreamedLights[lightid].barn_door_angle = degree
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightBarnDoorAngle", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype ~= "RECTLIGHT" then
		return false
	end

	return StreamedLights[lightid].barn_door_angle
end)

AddFunctionExport("SetLightBarnDoorLength", function(lightid, lenght)
	if lightid == nil or lenght == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype ~= "RECTLIGHT" then
		return false
	end

	StreamedLights[lightid].barn_door_lenght = lenght
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightBarnDoorLength", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype ~= "RECTLIGHT" then
		return false
	end

	return StreamedLights[lightid].barn_door_lenght
end)

AddFunctionExport("SetLightSourceHeight", function(lightid, height)
	if lightid == nil or height == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype ~= "RECTLIGHT" then
		return false
	end

	StreamedLights[lightid].source_height = height
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightSourceHeight", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype ~= "RECTLIGHT" then
		return false
	end

	return StreamedLights[lightid].source_height
end)

AddFunctionExport("SetLightSourceWidth", function(lightid, width)
	if lightid == nil or width == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype ~= "RECTLIGHT" then
		return false
	end

	StreamedLights[lightid].source_width = width
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightSourceWidth", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].lighttype ~= "RECTLIGHT" then
		return false
	end

	return StreamedLights[lightid].source_width
end)

AddFunctionExport("SetLightStreamRadius", function(lightid, distance)
	if lightid == nil or distance == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	SetObjectStreamDistance(lightid, distance)
	StreamedLights[lightid].stream_distance = distance
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("GetLightStreamRadius", function(lightid)
	if lightid == nil then
		return false
	end

	if StreamedLights[lightid] == nil then
		return false
	end

	return StreamedLights[lightid].stream_distance
end)

AddFunctionExport("SetLightDimension", function(lightid, dimension)
	if lightid == nil or dimension == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end
	return SetObjectDimension(lightid, dimension)
end)

AddFunctionExport("GetLightDimension", function(lightid)
	if lightid == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end
	return GetObjectDimension(lightid)
end)

AddFunctionExport("SetLightLocation", function(lightid, x, y, z)
	if lightid == nil or x == nil or y == nil or z == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end
	if StreamedLights[lightid].is_attached == true then
		return false -- Can't sent location of an attached light
	end
	SetObjectLocation(lightid, x, y, z)
	return true
end)

AddFunctionExport("GetLightLocation", function(lightid)
	if lightid == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].is_attached == true then
		return false
	end

	local x, y, z = GetObjectLocation(lightid)
	return x, y, z
end)

AddFunctionExport("SetLightRotation", function(lightid, rx, ry, rz)
	if lightid == nil or rx == nil or ry == nil or rz == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end
	SetObjectRotation(lightid, rx, ry, rz)
	return true
end)

AddFunctionExport("GetLightRotation", function(lightid)
	if lightid == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end
	local rx, ry, rz = GetObjectRotation(lightid)
	return rx, ry, rz
end)

AddFunctionExport("SetLightRandomLoopColor", function(lightid, interval)
	if lightid == nil or interval == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end

	loopcolor = CreateTimer(function()
		r = math.random(1, 255)
		g = math.random(1, 255)
		b = math.random(1, 255)
		color = RGB(r, g, b)
		StreamedLights[lightid].color = color
		SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	end, interval)

	StreamedLights[lightid].loopcolor = loopcolor
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("StopLightRandomLoopColor", function(lightid)
	if lightid == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].loopcolor == nil then
		return false
	end

	if DestroyTimer(StreamedLights[lightid].loopcolor) == false then
		return false
	end

	StreamedLights[lightid].loopcolor = nil
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("SetLightLoopRotation", function(lightid, xAxis, yAxis, zAxis, speed)
	if lightid == nil or (xAxis == nil and yAxis == nil and zAxis == nil) then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end

	xAxis = xAxis or 0
	yAxis = yAxis or 0
	zAxis = zAxis or 0
	speed = speed or 350

	looprotation = CreateTimer(function()
		local rx, ry, rz = GetObjectRotation(lightid)
		SetObjectRotation(lightid, rx + xAxis, ry + yAxis, rz + zAxis)
	end, speed)
	
	StreamedLights[lightid].looprotation = looprotation
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("StopLightLoopRotation", function(lightid)
	if lightid == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].looprotation == nil then
		return false
	end

	if DestroyTimer(StreamedLights[lightid].looprotation) == false then
		return false
	end

	StreamedLights[lightid].looprotation = nil
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("SetLightFlash", function(lightid, interval)
	if lightid == nil or interval == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end

	local currentcolor = StreamedLights[lightid].color
	local offcolor = RGB(0, 0, 0)

	local flashinterval = CreateTimer(function()
		if StreamedLights[lightid].color == currentcolor then
			StreamedLights[lightid].color = offcolor
		else
			StreamedLights[lightid].color = currentcolor
		end
		SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	end, interval)

	StreamedLights[lightid].flashinterval = flashinterval
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)

AddFunctionExport("StopLightFlash", function(lightid)
	if lightid == nil then
		return false
	end
	if StreamedLights[lightid] == nil then
		return false
	end

	if StreamedLights[lightid].flashinterval == nil then
		return false
	end

	if DestroyTimer(StreamedLights[lightid].flashinterval) == false then
		return false
	end

	StreamedLights[lightid].flashinterval = nil
	SetObjectPropertyValue(lightid, "_lightStream", StreamedLights[lightid])
	return true
end)