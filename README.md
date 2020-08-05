## Light Streamer

Serverside streamed lights.

This package allows you to add an unlimited amount of lights in the game world.

See here an exemple of utilisation : https://www.youtube.com/watch?v=CKusuBYyBPE&feature=youtu.be

### Exported server functions
```Lua
CreateLight(x, y, z, rx, ry, rz, lighttype, r, g, b, a, intensity, radius)
CreateAttachedLight(attach, id, x, y, z, rx, ry, rz, bone, lighttype, r, g, b, a, intensity, radius)
DestroyLight(lightid)
IsValidLight(lightid)
SetLightIntensity(lightid, intensity)
SetIntensityUnits(lightid, intensity)
SetLightColor(lightid, r, g, b, a)
SetLightAttenuationRadius(lightid, radius)
SetCastShadows(lightid, radius)
SetLightStreamRadius(lightid, radius)
SetLightDimension(lightid, dimension)
GetLightDimension(lightid)
SetLightLocation(lightid, x, y, z)
GetLightLocation(lightid)
GetAttachedLights(attach, id)
IsAttachedLight(lightid)
```

#### lighttype : 3 types can be used

```Lua 
POINTLIGHT : "Point"
SPOTLIGHT : "Spot" 
RECTLIGHT : "Rect"
```

See the UE4 doc for details about the differents light types :

https://docs.unrealengine.com/en-US/Engine/Rendering/LightingAndShadows/LightTypes/index.html

### SPOT LIGHT FUNCTION :
```Lua 
	SetOuterConeAngle(lightid, degree)
```

### POINT LIGHT FUNCTIONS :
```Lua 
SetLightFalloffExponent(lightid, fallof)
SetSoftSourceRadius(lightid, radius)
SetSourceLength(lightid, lenght)
SetSourceRadius(lightit, radius)
```

### RECT LIGHT FUNCTIONS :
```Lua 
SetBarnDoorAngle(lightid, degree)
SetBarnDoorLength(lightid, lenght)
SetSourceHeight(lightid, height)
SetSourceWidth(lightid, width)
```

### Data

- attach: ATTACH_VEHICLE, ATTACH_PLAYER, ATTACH_OBJECT, ATTACH_NPC
- id: entity id
- intensity: default 5000.0
- (stream)radius: default 6000.0

13000 is the max radius where the light will be streamed by the game ,beyond this limit this is useless.
- bone: string argument, see the WIKI for details:

https://dev.playonset.com/wiki/PlayerBones

https://dev.playonset.com/wiki/VehicleBones
- You can destroy attach lights with DestroyLight

### IMPORTANT : 

r, g, b, a are in linear color, see :
```Lua
-- Red color
SetLightColor(lightid, 1.0, 0.0, 0.0)
-- value goes from 0.0 to 1.0
```
- TIP : You're not forced to Destroy a light to "shut it down", you can just set the color to: 0.0, 0.0, 0.0 
- TIP 2 : Rotation is not necessary with a PointLight

- x, y, z in are Relative Location for an attached function, see :
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
