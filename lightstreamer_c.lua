--[[
This script is a modification of the soundstreamer package : 
https://github.com/BlueMountainsIO/OnsetLuaScripts/tree/master/soundstreamer

Modified By GalaxHD551
]]--

function OnScriptError(message)
	AddPlayerChat('<span color="#ff0000bb" style="bold" size="10">'..message..'</>')
end
AddEvent("OnScriptError", OnScriptError)

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

	for k, v in pairs(StreamedLights) do
		DestroySound(v.light)
	end

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
				local msg = "WARNING: The object is no more valid to create the light."
				AddPlayerChat('<span color="#ff0000bb" style="bold" size="10">'..msg..'</>')
				print(msg)
			end
			StreamedLights[object] = nil
			return
		else
			
			StreamedLights[object].light:SetRelativeRotation(FRotator(_lightStream.rx, _lightStream.ry, _lightStream.rz))
			StreamedLights[object].light:SetLightColor(FLinearColor(_lightStream.r, _lightStream.g, _lightStream.b, _lightStream.a), true)
			StreamedLights[object].light:SetIntensity(_lightStream.intensity)

		end

		if IsGameDevMode() then
			AddPlayerChat("STREAMIN: Server Light for Object "..object)
		end

	end

end)

AddEvent("OnObjectStreamOut", function(object)

	-- When the dummy object is streamed out make sure to destroy the light
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
		
		local CurrentPV = GetObjectPropertyValue(object, PropertyName)
		if CurrentPV.radius ~= PropertyValue.radius then
			StreamedLights[object].light:Destroy()
			local ObjectActor = GetObjectActor(object)
    		if PropertyValue.lighttype == "Spot" then
				StreamedLights[object].light = ObjectActor:AddComponent(USpotLightComponent.Class())
			elseif PropertyValue.lighttype == "Point" then
				StreamedLights[object].light = ObjectActor:AddComponent(UPointLightComponent.Class())
			elseif _lightStream.lighttype == "Rect" then
				StreamedLights[object].light = ObjectActor:AddComponent(URectLightComponent.Class())
			end
		end

		
		StreamedLights[object].light:SetRelativeRotation(FRotator(PropertyValue.rx, PropertyValue.ry, PropertyValue.rz))
		StreamedLights[object].light:SetLightColor(FLinearColor(PropertyValue.r, PropertyValue.g, PropertyValue.b, PropertyValue.a), true)
		StreamedLights[object].light:SetIntensity(PropertyValue.intensity)
	
	end

end)
