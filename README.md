## Sound Streamer

Serverside streamed lights.

This package allows you to add an unlimited amount of lights in the game world.

[![video]](https://youtu.be/CKusuBYyBPE)

### Exported server functions
```Lua
CreateLight(x, y, z, rx, ry, rz, lighttype, r, g, b, a, intensity, radius)
CreateAttachedSound3D(attach, id, x, y, z, rx, ry, rz, bone, lighttype, r, g, b, a, intensity, radius)
DestroyLight(lightid)
IsValidLight(lightid)
SetLightIntensity(lightid, intensity)
SetLightColor(lightid, r, g, b, a)
SetLightRadius(lightid, radius)
SetLightDimension(soundid, dimension)
GetLightDimension(soundid)
SetLightLocation(soundid, x, y, z)
GetLightLocation(soundid)
GetAttachedLights(attach, id)
IsAttachedLight3D(soundid)
```
- lighttype : 3 types: 
```Lua 
"Point"
"Spot" 
"Rect"
```
see the UE4 doc for details:
https://docs.unrealengine.com/en-US/Engine/Rendering/LightingAndShadows/LightTypes/index.html
Using Rotation is useless with a PointLight

- attach: ATTACH_VEHICLE, ATTACH_PLAYER, ATTACH_OBJECT, ATTACH_NPC
- id: entity id
- intensity: default 5000.0
- radius: default 6000.0
13000 is the max radius where the light will be streamed by the game ,beyond this limit this is useless.
- bone: string argument, see the WIKI for details:
https://dev.playonset.com/wiki/PlayerBones
https://dev.playonset.com/wiki/VehicleBones
- You can destroy attach lights with DestroyLight

- IMPORTANT : 
r,g,b,a are in linear color ! see :
```Lua
-- Red color
SetLightColor(lightid, 1.0, 0.0, 0.0, 0.0)
-- value goes from 0.0 to 1.0
```
x, y, z in AttachedLight are Relative Location from the attached object ! see :
```Lua
	lr.CreateAttachedLight(ATTACH_PLAYER, player, -80, 0, 1, 90, 0, 0, "hand_r", "Spot")
```


#### Example Usage 
```Lua
lr = ImportPackage("lightstreamer")

function OnPackageStart()
	local light = lr.CreateLight(126016.046875, 81475.203125, 1500.0, 0.0, 0.0, 0.0, "Point")
	lr.SetLightIntensity(light, 100000)
	CreateTimer(function()
		r = RandomFloat(0, 1)
		g = RandomFloat(0, 1)
		b = RandomFloat(0, 1)
		lr.SetLightColor(light, r, g, b)
	end, 500)
end
AddEvent("OnPackageStart", OnPackageStart)
```