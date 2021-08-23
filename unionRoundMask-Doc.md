## unionRoundMask / unionRound  
---
### Union with round fillet at selected places. Created for Round-Anything by TLC123 (2021).  
A shortcut for faster fillet union is enabled when the operation constrained to convex operands.  
For most cases unionRoundMask / unionRound replaces MinkowskiRound.  
Combined with a system of mask selectors, unionRound becomes even more versetile.

![unionround-doc-example](https://user-images.githubusercontent.com/10944617/130456818-c5fd43d1-e6df-4e88-8474-aed1a0c3ca31.png)

## unionRoundMask 
---
Union with round fillet at selected places.
### module unionRoundMask(r=1, detail = 5 , q=70, epsilon = 1e-6, showMask = true , includeOperands = true) 

Masks are a method to perform unionRound on selected only areas,  
and circumvents the previous limitation to common convex work area.  
Mask are essentially just common primitives that is used to mark out areas by intersection.

r:  
   * approximate radius for fillet. Exact radius is dependant on crease angle.  
   * detail: numbers of fillet segments. 1 is essensially  a chamfer/bevel.      
   * Set low for faster preview. ( $preview?3:10 )

q:  
   * determine how detailed clad operations are.    
   * Set low for faster preview. ( $preview?30:70 )

epsilon:   
   * For debugging, leave as is.

showMask:  
   * For debugging, try it.
   
includeOperands:  
   * For debugging, render only fillet when false.

### usage:
````
unionRoundMask( r = 1 , detail = $preview ? 3 : 10 , q = $preview ? 30 : 70 )
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
````

---
## unionRound
---
### module unionRound(r=1, detail = 5 , q=70,  epsilon = 1e-6 , includeOperands = true )

Module unionRound is the underlying work module of unionRoundMask. 
It can be used by it self, in some cases faster but more raw.

### usage:
````
unionRoundMask( r = 1 , detail = $preview ? 3 : 10 , q= $preview ? 30 : 70 )
{
    yourObject1();
    yourObject2();
}
````

---
## intersectionRound
---
module intersectionRound(r, q=70,  epsilon = 1e-6,showOperands = true) 
prototype module  
Undocumented for now.  

--- 
## helpers
---
````
 module  clad(r,q=70) // speed is limited to convex operand.   
 module shell(r,q=70) // not in use.   
 module inset(r,q=20) // speed is limited to convex operand.   
````
---
## Citation        
---
### roundUnionMask Includes code based on examples from:  
    Kogan, Jonathan (2017)  
    "A New Computationally Efficient Method for Spacing n Points on a Sphere,"  
    Rose-Hulman Undergraduate Mathematics Journal: Vol. 18 : Iss. 2 , Article 5.  
    Available at: [https://scholar.rose-hulman.edu/rhumj/vol18/iss2/5]  
