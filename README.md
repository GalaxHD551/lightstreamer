## Light Streamer

Serverside streamed lights.

This package allows you to add an unlimited amount of lights in the game world.

See here an exemple of utilisation : https://www.youtube.com/watch?v=CKusuBYyBPE&feature=youtu.be

### Exported server functions
```Lua
CreateLight(lighttype, x, y, z[, rx, ry, rz, color, intensity, streamradius])
SetLightAttached(lightid, attachtype, attachid[, x, y, z, rx, ry, rz, SocketName])
DestroyLight(lightid)
IsValidLight(lightid)
SetLightIntensity(lightid, intensity)
SetIntensityUnits(lightid, intensity)
SetLightColor(lightid, color)
SetLightAttenuationRadius(lightid, radius)
SetCastShadows(lightid, bEnable)
SetLightStreamRadius(lightid, radius)
SetLightDimension(lightid, dimension)
GetLightDimension(lightid)
SetLightLocation(lightid, x, y, z)
GetLightLocation(lightid)
GetAttachedLights(attach, id)
IsAttachedLight(lightid)
SetLightDetached(lightid)

SetLightRandomLoopColor(lightid, interval)
StopLightRandomLoopColor(lightid)
SetLightLoopRotation(lightid, xAxis, yAxis, zAxis[, speed])
StopLightLoopRotation(lightid)
SetLightFlash(lightid, interval)
StopLightFlash(lightid)
```

#### lighttype : 3 types can be used

```Lua 
POINTLIGHT : "POINTLIGHT"
SPOTLIGHT : "SPOTLIGHT" 
RECTLIGHT : "RECTLIGHT"
```

See the UE4 doc for details about the differents light types :

https://docs.unrealengine.com/en-US/Engine/Rendering/LightingAndShadows/LightTypes/index.html

### Spot light function :
```Lua 
SetOuterConeAngle(lightid, degree)
```

### Point light functions :
```Lua 
SetLightFalloffExponent(lightid, fallof)
SetSoftSourceRadius(lightid, radius)
SetSourceLength(lightid, lenght)
SetSourceRadius(lightit, radius)
```

### Rect light functions :
```Lua 
SetBarnDoorAngle(lightid, degree)
SetBarnDoorLength(lightid, lenght)
SetSourceHeight(lightid, height)
SetSourceWidth(lightid, width)
```

### Data

- attach: ATTACH_VEHICLE, ATTACH_PLAYER, ATTACH_OBJECT, ATTACH_NPC
- attachid: entity id
- intensity: default 5000.0
- streamradius: default 12000.0
13000 is the max radius where the light will be streamed by the game ,beyond this limit the light will be not visible at all.

- SocketName: string argument, see the WIKI for details:

https://dev.playonset.com/wiki/PlayerBones

https://dev.playonset.com/wiki/VehicleBones
- You can destroy attach lights with DestroyLight

### IMPORTANT : 

- Color :
```Lua
-- Red color
color = RGB(255, 0, 0)
SetLightColor(lightid, color)
```
- TIP : You're not forced to Destroy a light to "shut it down", you can just set the color to black
- TIP 2 : Rotation isn't necessary with PointLight

- x, y, z are relative location for an attached light, see :
```Lua
lr.SetLightAttached(lightid, ATTACH_PLAYER, player, -80, 0, 1, 90, 0, 0, "hand_r")
```

#### Example Usage 
```Lua
lr = ImportPackage("lightstreamer")

function OnPackageStart()
	local light = lr.CreateLight("POINTLIGHT", 126016.046875, 81475.203125, 1550.0)
	lr.SetLightIntensity(light, 100000)
	lr.SetLightRandomLoopColor(light, 2000)
end
AddEvent("OnPackageStart", OnPackageStart)
```
