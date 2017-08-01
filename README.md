# Round-Anything

### minkowskiRound();
Is an incredibly powerful module that will allow you to fillet any of your OpenSCAD modules retrospectively while keeping the original dimensions. You don't need design your part again, or start using rounded cube modules etc, just throw minkowskiRound() out the front of it and your good to go. Also I hope the example in the first picture demonstrates that besides convenience of not having to add each fillet yourself, it will also fillet some areas (internal corners in particular) that are near impossible to fillet with other methods in SCAD.

Biggest downside is that it is very computationally intensive, you will have to keep the $fn low (I would recommend 10-15 as a starting point) unless you are willing to wait a long time (12 hours plus). The modules have been made with an enable variable so that you can disable the module and keep designing and only add the fillets when you are ready to output your final model.
There is also a minkowskiInsideRound() and minkowskiOutsideRound() which takes less time to render if you only need inside or outside radii

### round2d();
Allows you to round any 2d object in openscad

### polyRound();
is used the same way that polygon(); is used, however along with a list of coordinates, a list of radiuses should also be supplied and the corners will be rounded with these radiuses.
This is can be incredible useful if you try and design parts using extruded 2d polygons instead of with primatives since radiuses are generally hard to implement in OpenSCAD (internal radiuses in particular). see examples below.

I would love if people sent me examples that I can upload along with the ones I have here. 

[thingiverse page here](https://www.thingiverse.com/thing:2419664)

### Examples
##### minkowsikRound();
<img src="https://github.com/Irev-Dev/Round-Anything/blob/master/images/mainminkowski.png" width="100%" align="left"> 

##### minkowsikInsideRound(); & minkowsikOutsideRound();
<img src="https://github.com/Irev-Dev/Round-Anything/blob/master/images/InOutminkowski.png" width="100%" align="left"> 

##### round2d();
<img src="https://github.com/Irev-Dev/Round-Anything/blob/master/images/round2d.png" width="100%" align="left"> 

##### polyRound();
<img src="https://github.com/Irev-Dev/Round-Anything/blob/master/images/example1.png" width="100%" align="left"> 
<img src="https://github.com/Irev-Dev/Round-Anything/blob/master/images/PolyRoundexample3fn.png" width="100%" align="left"> 
<img src="https://github.com/Irev-Dev/Round-Anything/blob/master/images/example2.png" width="100%" align="left"> 

