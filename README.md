# Light Streamer

Serverside streamed lights.

This package allows you to add an unlimited amount of lights in the game world.

See here an exemple of utilisation : https://www.youtube.com/watch?v=CKusuBYyBPE&feature=youtu.be

Here, you will find informations about the package, like functions and codes exemple.

# Table of content
## [Changelog](https://github.com/GalaxHD551/lightstreamer/wiki/Changelog)
## [Import package](https://dev.playonset.com/wiki/ImportPackage)
## [Lighting basics](https://docs.unrealengine.com/en-US/Engine/Rendering/LightingAndShadows/Basics/index.html)
## [Light type](https://github.com/GalaxHD551/lightstreamer/wiki/Light-type)
## [Functions](https://github.com/GalaxHD551/lightstreamer/wiki/Functions)
  - ### [Basics functions](https://github.com/GalaxHD551/lightstreamer/wiki/Functions#functions-used-by-all-lights-types)
  - ### [Point light functions](https://github.com/GalaxHD551/lightstreamer/wiki/Functions#pointlight-functions)
  - ### [Spot light function](https://github.com/GalaxHD551/lightstreamer/wiki/Functions#spotlight-functions)
  - ### [Rect light functions](https://github.com/GalaxHD551/lightstreamer/wiki/Functions#rectlight-functions)
  - ### [Customs functions](https://github.com/GalaxHD551/lightstreamer/wiki/Functions#customs-functions)


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
