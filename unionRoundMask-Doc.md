#unionRoundMask
module unionRoundMask(r=1, detail = 5 , q=70, epsilon = 1e-6, showMask = true) 

Masks are a method to perform unionRound on selected only areas 
and circumvents the limitation of common convex work area
Mask are just common primitives that is used to mark out areas.

usage:
unionRoundMask(r=1,detail=3,q=30)
{
    yourObject1();
    yourObject2();
        yourMask1();
        yourMask2();
        yourMask3();
    //    ...
    //    ...
    //    ...
}

#unionRound
module unionRound(r=1, detail = 5 , q=70,  epsilon = 1e-6)

Module unionRound is the underlying work module of unionRoundMask. 
It can be used by it self, in some cases faster but more raw.

usage:
unionRoundMask(r=1,detail=3,q=30)
{
    yourObject1();
    yourObject2();
}


#intersectionRound
module intersectionRound(r, q=70,  epsilon = 1e-6,showOperands = true) {
Undocumented for now.

//helpers
module  clad(r,q=70) // speed is limited to convex operand
module shell(r,q=70) // not in use
module inset(r,q=20) // speed is limited to convex operand

## Citation        
roundUnionMask Includes code based on examples from:
    Kogan, Jonathan (2017) "A New Computationally Efficient Method for Spacing n Points on a Sphere," Rose-Hulman Undergraduate Mathematics Journal: Vol. 18 : Iss. 2 , Article 5.
    Available at: [https://scholar.rose-hulman.edu/rhumj/vol18/iss2/5]