# Round-Anything

Is an incredibly powerful module that will allow you to fillet any of your OpenSCAD modules retrospectively while keeping the original dimensions. You don't need design your part again, or start using rounded cube modules etc, just throw minkowskiRound() out the front of it and your good to go. Also I hope the example in the first picture demonstrates that besides convenience of not having to add each fillet yourself, it will also fillet some areas (internal corners in particular) that are near impossible to fillet with other methods in SCAD.

Biggest downside is that it is very computationally intensive, you will have to keep the $fn low (I would recommend 10-15 as a starting point) unless you are willing to wait a long time (12 hours plus). The modules have been made with an enable variable so that you can disable the module and keep designing and only add the fillets when you are ready to output your final model.

I would love if people sent me examples that I can upload along with the ones I have here. 
I'm going to try and see if I can get this added the the MCAD library.

[thingiverse page here](https://www.thingiverse.com/thing:2419664)
