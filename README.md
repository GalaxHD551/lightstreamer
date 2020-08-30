## Light Streamer

Serverside streamed lights.

This package allows you to add an unlimited amount of lights in the game world.

See here an exemple of utilisation : https://www.youtube.com/watch?v=CKusuBYyBPE&feature=youtu.be

All informations are given on the wiki, please have a look :
https://github.com/GalaxHD551/lightstreamer/wiki

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
