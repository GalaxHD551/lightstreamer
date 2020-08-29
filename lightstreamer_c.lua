--[[
This script is a modification of the soundstreamer package : 
https://github.com/BlueMountainsIO/OnsetLuaScripts/tree/master/soundstreamer

Modified By GalaxHD551
]]--

local StreamedLights = { }

-- Expose attach types like on the server.
if ATTACH_NONE == nil then
	ATTACH_NONE = 0
end
if ATTACH_PLAYER == nil then
	ATTACH_PLAYER = 1
end
if ATTACH_VEHICLE == nil then
	ATTACH_VEHICLE = 2
end
if ATTACH_OBJECT == nil then
	ATTACH_OBJECT = 3
end
if ATTACH_NPC == nil then
	ATTACH_NPC = 4
end

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
		ObjectActor:SetActorHiddenInGame(true)

		-- Alos disable its collision
		ObjectActor:SetActorEnableCollision(false)

		local x, y, z

		if _lightStream.is_attached == false then

			x, y, z = GetObjectLocation(object)

		elseif _lightStream.is_attached == true then

			if _lightStream.attach == ATTACH_VEHICLE then
				
				x, y, z = GetVehicleLocation(_lightStream.id)

			elseif _lightStream.attach == ATTACH_PLAYER then

				x, y, z = GetPlayerLocation(_lightStream.id)

			elseif _lightStream.attach == ATTACH_OBJECT then

				x, y, z = GetObjectLocation(_lightStream.id)				

			elseif _lightStream.attach == ATTACH_NPC then

				x, y, z = GetNPCLocation(_lightStream.id)			

			end
		end

		-- Create the actual light
		if _lightStream.lighttype == "Spot" then
			StreamedLights[object].light = ObjectActor:AddComponent(USpotLightComponent.Class())
		elseif _lightStream.lighttype == "Point" then
			StreamedLights[object].light = ObjectActor:AddComponent(UPointLightComponent.Class())
		elseif _lightStream.lighttype == "Rect" then
    		StreamedLights[object].light = ObjectActor:AddComponent(URectLightComponent.Class())
		end

		if StreamedLights[object].light == false then
			if IsGameDevMode() then
				local msg = "ERROR: The object is no more valid to create the light."
				AddPlayerChat('<span color="#ff0000bb" style="bold" size="10">'..msg..'</>')
				print(msg)
			end
			StreamedLights[object] = nil
			return
		else
			
			StreamedLights[object].light:SetRelativeRotation(FRotator(_lightStream.rx, _lightStream.ry, _lightStream.rz))
			StreamedLights[object].light:SetLightColor(FLinearColor(_lightStream.r, _lightStream.g, _lightStream.b, 1.0), true)
			StreamedLights[object].light:SetIntensity(_lightStream.intensity)

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

AddEvent("OnObjectNetworkUpdatePropertyValue", function(object, PropertyName, PropertyValue)

	if StreamedLights[object] == nil then
		return
	end

	if PropertyName == "_lightStream" then

		if PropertyValue.lighttype == "Spot" then
			if PropertyValue.spot_angle ~= nil then
				StreamedLights[object].light:SetOuterConeAngle(PropertyValue.spot_angle)
			end
		elseif PropertyValue.lighttype == "Point" then
			if PropertyValue.point_fallof ~= nil then
				StreamedLights[object].light:SetLightFalloffExponent(PropertyValue.point_fallof)
			end
			if PropertyValue.point_softradius ~= nil then
				StreamedLights[object].light:SetSoftSourceRadius(PropertyValue.point_softradius)
			end
			if PropertyValue.point_lenght ~= nil then
				StreamedLights[object].light:SetSourceLength(PropertyValue.point_lenght)
			end
			if PropertyValue.point_radius ~= nil then
				StreamedLights[object].light:SetSourceRadius(PropertyValue.point_radius)
			end
		elseif _lightStream.lighttype == "Rect" then
			if PropertyValue.rect_angle ~= nil then
				StreamedLights[object].light:SetBarnDoorAngle(PropertyValue.rect_angle)
			end
			if PropertyValue.rect_lenght ~= nil then
				StreamedLights[object].light:SetBarnDoorLength(PropertyValue.rect_lenght)
			end
			if PropertyValue.rect_height ~= nil then
				StreamedLights[object].light:SetSourceHeight(PropertyValue.rect_height)
			end
			if PropertyValue.rect_width ~= nil then
				StreamedLights[object].light:SetSourceWidth(PropertyValue.rect_width)
			end
		end

		
		StreamedLights[object].light:SetRelativeRotation(FRotator(PropertyValue.rx, PropertyValue.ry, PropertyValue.rz))
		StreamedLights[object].light:SetLightColor(FLinearColor(PropertyValue.r, PropertyValue.g, PropertyValue.b, 1.0), true)
		StreamedLights[object].light:SetIntensity(PropertyValue.intensity)

		if PropertyValue.attenuation_radius ~= nil then
			StreamedLights[object].light:SetAttenuationRadius(PropertyValue.attenuation_radius)
		end
		if PropertyValue.intensityU ~= nil then
			StreamedLights[object].light:SetIntensityUnits(PropertyValue.intensityU)
		end
		if PropertyValue.shadow ~= nil then
			StreamedLights[object].light:SetCastShadows(PropertyValue.shadow)
		end

	end

end)
