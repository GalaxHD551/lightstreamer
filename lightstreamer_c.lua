--[[
This script is a modification of the soundstreamer package : 
https://github.com/BlueMountainsIO/OnsetLuaScripts/tree/master/soundstreamer
Modified By GalaxHD551
]]--

local StreamedLights = { }

AddEvent("OnPackageStop", function()
	StreamedLights = nil
end)

AddEvent("OnObjectStreamIn", function(object)
	if StreamedLights[object] ~= nil then
		print("ERROR: OnObjectStreamIn("..object..") called where we already have one")
		return
	end
	local _lightStream = GetObjectPropertyValue(object, "_lightStream")
	if _lightStream ~= nil then
		StreamedLights[object] = { }
		StreamedLights[object] = _lightStream
		local ObjectActor = GetObjectActor(object)
		-- Set the scale to 0 and make it hidden
		ObjectActor:SetActorScale3D(FVector(0.01, 0.01, 0.01))
		GetObjectStaticMeshComponent(object):SetHiddenInGame(true)
		-- Alos disable its collision
		ObjectActor:SetActorEnableCollision(false)
		-- Create the actual light
		if _lightStream.lighttype == "SPOTLIGHT" then
			StreamedLights[object].light = ObjectActor:AddComponent(USpotLightComponent.Class())
		elseif _lightStream.lighttype == "POINTLIGHT" then
			StreamedLights[object].light = ObjectActor:AddComponent(UPointLightComponent.Class())
		elseif _lightStream.lighttype == "RECTLIGHT" then
    		StreamedLights[object].light = ObjectActor:AddComponent(URectLightComponent.Class())
		end
		if StreamedLights[object].light == false or StreamedLights[object].light == nil then
			if IsGameDevMode() then
				local msg = "ERROR: An error occurred while creating the light."
				AddPlayerChat('<span color="#ff0000bb" style="bold" size="10">'..msg..'</>')
				print(msg)
			end
			StreamedLights[object] = nil
			return
		else
			SetUpLight(object, _lightStream)
		end

		if IsGameDevMode() then
			AddPlayerChat("STREAMIN: Server Light for Object "..object)
		end
	end
end)

AddEvent("OnObjectStreamOut", function(object)
	-- When the object containing the light is streamed out make sure to destroy the light
	if StreamedLights[object] ~= nil then
		StreamedLights[object].light:Destroy()
		if IsGameDevMode() then
			AddPlayerChat("STREAMOUT: Server Light "..object)
		end
		StreamedLights[object] = nil
	end
end)

AddEvent("OnObjectNetworkUpdatePropertyValue", function(object, PropertyName, _lightStream)
	if StreamedLights[object] == nil then
		return
	end
	if PropertyName == "_lightStream" then
		SetUpLight(object, _lightStream)
	end
end)

function SetUpLight(object, _lightStream)
	local r, g, b = HexToRGBAFloat(_lightStream.color)
	StreamedLights[object].light:SetLightColor(FLinearColor(r, g, b, 1.0))
	StreamedLights[object].light:SetAttenuationRadius(_lightStream.attenuation_radius)
	StreamedLights[object].light:SetCastShadows(_lightStream.shadow)
	if _lightStream.intensityU ~= nil then
		StreamedLights[object].light:SetIntensityUnits(ELightUnits._lightStream.intensityU)
	end
	StreamedLights[object].light:SetIntensity(_lightStream.intensity)
	if _lightStream.lighttype == "SPOTLIGHT" then
		StreamedLights[object].light:SetOuterConeAngle(_lightStream.outer_cone)
		StreamedLights[object].light:SetInnerConeAngle(_lightStream.inner_cone)
		StreamedLights[object].light:SetLightFalloffExponent(_lightStream.falloff)
		StreamedLights[object].light:SetSourceLength(_lightStream.source_lenght)
		StreamedLights[object].light:SetSourceRadius(_lightStream.source_radius)
		StreamedLights[object].light:SetSoftSourceRadius(_lightStream.soft_source_radius)
	elseif _lightStream.lighttype == "POINTLIGHT" then
		StreamedLights[object].light:SetLightFalloffExponent(_lightStream.falloff)	
		StreamedLights[object].light:SetSoftSourceRadius(_lightStream.soft_source_radius)
		StreamedLights[object].light:SetSourceLength(_lightStream.source_lenght)
		StreamedLights[object].light:SetSourceRadius(_lightStream.source_radius)
	elseif _lightStream.lighttype == "RECTLIGHT" then
		StreamedLights[object].light:SetBarnDoorAngle(_lightStream.barn_door_angle)
		StreamedLights[object].light:SetBarnDoorLength(_lightStream.barn_door_lenght)
		StreamedLights[object].light:SetSourceHeight(_lightStream.source_height)
		StreamedLights[object].light:SetSourceWidth(_lightStream.source_width)
	end
end

AddFunctionExport("GetStreamedLights", function()
	local _table = {}
	for k, v in ipairs(StreamedLights) do
		table.insert(_table, k)
	end
	return  _table
end)