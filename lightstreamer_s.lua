--[[
This script is a modification of the soundstreamer package : 
https://github.com/BlueMountainsIO/OnsetLuaScripts/tree/master/soundstreamer

Modified By GalaxHD551
]]--

local StreamedLights = { }

AddEvent("OnPackageStop", function()

	for k, v in pairs(StreamedLights) do
		DestroyObject(k)
	end

	StreamedLights = nil

end)

AddFunctionExport("CreateLight", function (x, y, z, rx, ry, rz, lighttype, r, g, b, intensity, streamradius)

	if x == nil or y == nil or z == nil or lighttype == nil then
		return false
	end

	rx = rx or 0.0
	ry = ry or 0.0
	rz = rz or 0.0
	r = r or 255.0
	g = g or 255.0
	b = b or 255.0
	intensity = intensity or 5000.0
	radius = streamradius or 6000.0

	-- Create an object that will help us to attach the light to it
	local object = CreateObject(1, x, y, z)

	if object == false then
		return false
	end

	SetObjectStreamDistance(object, radius)

	local _lightStream = { }
	_lightStream.is_attached = false
	_lightStream.rx = rx
	_lightStream.ry = ry
	_lightStream.rz = rz
	_lightStream.lighttype = lighttype
	_lightStream.r = r
	_lightStream.g = g
	_lightStream.b = b
	_lightStream.intensity = intensity
	_lightStream.intensity = radius

	SetObjectPropertyValue(object, "_lightStream", _lightStream)

	StreamedLights[object] = _lightStream

	return object
end)

AddFunctionExport("CreateAttachedLight", function(attach, id, x, y, z, rx, ry, rz, bone, lighttype, r, g, b, intensity, streamradius)

	if id == nil or attach == nil or lighttype == nil then
		return false
	end

	x = x or 0.0
	y = y or 0.0
	z = z or 0.0
	rx = rx or 0.0
	ry = ry or 0.0
	rz = rz or 0.0
	bone = bone or nil
	r = r or 255.0
	g = g or 255.0
	b = b or 255.0
	intensity = intensity or 5000.0
	radius = streamradius or 6000.0

	local object = CreateObject(1, 0.0, 0.0, 0.0)
	
	if object == false then
		return false
	end

	local _lightStream = { }
	_lightStream.is_attached = true
	_lightStream.id = id
	_lightStream.attach = attach
	_lightStream.rx = rx
	_lightStream.ry = ry
	_lightStream.rz = rz
	_lightStream.lighttype = lighttype
	_lightStream.r = r
	_lightStream.g = g
	_lightStream.b = b
	_lightStream.intensity = intensity
	_lightStream.radius = radius

	SetObjectPropertyValue(object, "_lightStream", _lightStream)

	if SetObjectAttached(object, attach, id, x, y, z, rx, ry, rz, bone) == false then
		DestroyObject(object)
		return false
	end

	StreamedLights[object] = _lightStream

	return object
end)

AddFunctionExport("GetAttachedLights", function(attach, id)
	
	if attach == nil or id == nil then
		return false
	end

	local lights = { }

	for k, v in pairs(StreamedLights) do
		if v.is_attached == true then
			if v.attach == attach and v.id == id then
				table.insert(lights, k)
			end
		end
	end

	return lights
end)

AddFunctionExport("DestroyLight", function(object)
	if object == nil then
		return false
	end
	if StreamedLights[object] == nil then
		return false
	end
	StreamedLights[object] = nil
	return DestroyObject(object)
end)

AddFunctionExport("IsValidLight", function(object)
	return StreamedLights[object] ~= nil
end)

AddFunctionExport("IsAttachedLight", function(object)
	if StreamedLights[object] == nil then
		return false
	end
	return StreamedLights[object].is_attached
end)

AddFunctionExport("SetLightIntensity", function(object, intensity)
	if object == nil then
		return false
	end

	intensity = intensity or 5000.0

	if StreamedLights[object] == nil then
		return false
	end

	StreamedLights[object].intensity = intensity
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetLightColor", function(object, r, g, b)
	if object == nil then
		return false
	end

	r = r or 255
	g = g or 255
	b = b or 255

	if StreamedLights[object] == nil then
		return false
	end
	StreamedLights[object].r = r
	StreamedLights[object].g = g
	StreamedLights[object].b = b
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])	

	return true
end)

AddFunctionExport("SetLightAttenuationRadius", function(object, radius)
	if object == nil then
		return false
	end

	attenuation_radius = attenuation_radius or 5000.0

	if StreamedLights[object] == nil then
		return false
	end

	StreamedLights[object].attenuation_radius = attenuation_radius
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetIntensityUnits", function(object, intensityU)
	if object == nil then
		return false
	end

	intensityU = intensityU or 1000.0

	if StreamedLights[object] == nil then
		return false
	end

	StreamedLights[object].intensityU = intensityU
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetLightFalloffExponent", function(object, fallof)
	if object == nil then
		return false
	end

	point_fallof = fallof or 1000.0

	if StreamedLights[object] == nil then
		return false
	end

	if StreamedLights[object].lighttype ~= "Point" then
		return false
	end

	StreamedLights[object].point_fallof = point_fallof
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetSoftSourceRadius", function(object, radius)
	if object == nil then
		return false
	end

	point_softradius = radius or 60.0

	if StreamedLights[object] == nil then
		return false
	end

	if StreamedLights[object].lighttype ~= "Point" then
		return false
	end

	StreamedLights[object].point_softradius = point_softradius
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetSourceLength", function(object, lenght)
	if object == nil then
		return false
	end

	point_lenght = lenght or 1000.0

	if StreamedLights[object] == nil then
		return false
	end

	if StreamedLights[object].lighttype ~= "Point" then
		return false
	end

	StreamedLights[object].point_lenght = point_lenght
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetSourceRadius", function(object, radius)
	if object == nil then
		return false
	end

	point_radius = radius or 60.0

	if StreamedLights[object] == nil then
		return false
	end

	if StreamedLights[object].lighttype ~= "Point" then
		return false
	end

	StreamedLights[object].point_radius = point_radius
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetCastShadows", function(object, bEnable)
	if object == nil then
		return false
	end

	shadow = bEnable or true

	if StreamedLights[object] == nil then
		return false
	end

	StreamedLights[object].shadow = shadow
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetOuterConeAngle", function(object, degree)
	if object == nil then
		return false
	end

	spot_angle = degree or 60.0

	if StreamedLights[object] == nil then
		return false
	end

	if StreamedLights[object].lighttype ~= "Spot" then
		return false
	end

	StreamedLights[object].spot_angle = spot_angle
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetBarnDoorAngle", function(object, degree)
	if object == nil then
		return false
	end

	rect_angle = degree or 60.0

	if StreamedLights[object] == nil then
		return false
	end

	if StreamedLights[object].lighttype ~= "Rect" then
		return false
	end

	StreamedLights[object].rect_angle = rect_angle
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetBarnDoorLength", function(object, lenght)
	if object == nil then
		return false
	end

	rect_lenght = lenght or 1000.0

	if StreamedLights[object] == nil then
		return false
	end

	if StreamedLights[object].lighttype ~= "Rect" then
		return false
	end

	StreamedLights[object].rect_lenght = rect_lenght
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetSourceHeight", function(object, height)
	if object == nil then
		return false
	end

	rect_height = height or 1000.0

	if StreamedLights[object] == nil then
		return false
	end

	if StreamedLights[object].lighttype ~= "Rect" then
		return false
	end

	StreamedLights[object].rect_height = rect_height
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetSourceWidth", function(object, width)
	if object == nil then
		return false
	end

	rect_width = width or 1000.0

	if StreamedLights[object] == nil then
		return false
	end

	if StreamedLights[object].lighttype ~= "Rect" then
		return false
	end

	StreamedLights[object].rect_width = rect_width
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetLightStreamRadius", function(object, radius)
	if object == nil then
		return false
	end

	radius = radius or 6000.0

	if StreamedLights[object] == nil then
		return false
	end

	StreamedLights[object].radius = radius
	SetObjectPropertyValue(object, "_lightStream", StreamedLights[object])
	return true
end)

AddFunctionExport("SetLightDimension", function(object, dimension)
	if object == nil or dimension == nil then
		return false
	end
	if StreamedLights[object] == nil then
		return false
	end
	return SetObjectDimension(object, dimension)
end)

AddFunctionExport("GetLightDimension", function(object)
	if object == nil then
		return false
	end
	if StreamedLights[object] == nil then
		return false
	end
	return GetObjectDimension(object)
end)

AddFunctionExport("SetLightLocation", function(object, x, y, z)
	if object == nil or x == nil or y == nil or z == nil then
		return false
	end
	if StreamedLights[object] == nil then
		return false
	end
	if StreamedLights[object].is_attached == true then
		return false -- Can't sent location of an attached light
	end
	SetObjectLocation(object, x, y, z)
	return true
end)

AddFunctionExport("GetLightLocation", function(object)
	if object == nil then
		return false
	end
	if StreamedLights[object] == nil then
		return false
	end

	if StreamedLights[object].is_attached == true then
		return false
	end

	local x, y, z = GetObjectLocation(object)
	return x, y, z
end)
