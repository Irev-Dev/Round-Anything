# Round-Anything

Round-Anything is primarily a set of OpenSCAD utilities that help with rounding parts, but it also embodies a robust approach to developing OpenSCAD parts. The heart of the library a list of polygon points, with a 3rd radius parameter at each point. That is a series of [x, y, radius] points.

<img src="https://cdn.sanity.io/images/2hqqc7om/production/5d73db6dfd44ab2606d5e3ff5d993361eba61c5e-1371x1567.png?w=500&h=571&fit=crop" width="100%" align="left"> 

## The Why

The truth is radii, internal radii in particular can be a real pain to add in openscad. and the more you move away from shapes with 90 degree angles the more difficult it becomes, effectively puting a complexity ceiling on parts you can produce in OpenScad. Because of how important radii in both making a apealing and strong part, reducing stress concentration etc, A library that focuses on radii as a core principle makes for a solid foundation for your parts. Furthermore the heart of the library revolves around the polygon, this is because we're leveraging the battle tested paradigm of extruding from 2d sketches of most CAD packages. I can't imagine making an OpenScad part without Round-Anything.

### Quick side-notes

I'm currently working on a community website for "Code-CAD" (like OpenSCAD). A good way to think of it is codepen crossed with a thing repository. You can check it out at [cadhub.xyz](https://cadhub.xyz/) or it's [repo](https://github.com/Irev-Dev/cadhub).

Also please submit examples of what you build with the library in the [discussions](https://github.com/Irev-Dev/Round-Anything/discussions), I'd love to see them. I also recommend you "watch" the repo with notifications turned on for the discussions to stay up-to-date.

## Documentation

See an overview of the library in [video form](https://www.youtube.com/watch?v=laxv2wFKq8Q)

<a href="https://www.youtube.com/watch?v=laxv2wFKq8Q"><img src="https://i.ytimg.com/vi/laxv2wFKq8Q/sddefault.jpg" width="100%" align="left"></a>


[Written overview](https://kurthutten.com/blog/round-anything-a-pragmatic-approach-to-openscad-design/).

[Full documentation of the API is here](https://kurthutten.com/blog/round-anything-api/).

[Installation instructions](https://github.com/Irev-Dev/Round-Anything/discussions/21)

## Extra

I [live streamed](https://www.youtube.com/watch?v=1Tegarwy69I&t=2s) the making of [this part](https://github.com/Irev-Dev/monitor-stand-turn-camera) using this library. I was able to make the bulk of this part quickly even with some complex radii involved thanks to the library.

<img src="https://cdn.thingiverse.com/assets/ea/fb/83/89/57/featured_preview_camera_mount.png" width="100%" align="left">

Below are some of the example parts that can be found in [roundAnythingExamples.scad](https://github.com/Irev-Dev/Round-Anything/blob/master/roundAnythingExamples.scad).

<img src="https://cdn.sanity.io/images/2hqqc7om/production/2dba6301d1f25b1c45a634058b280b52fa713b60-1920x1080.png?w=1920&h=1000&fit=crop" width="100%" align="left">
