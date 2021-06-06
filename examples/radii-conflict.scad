// radii conflict example

include <Round-Anything-1.0.4/polyround.scad>

//example of radii conflict handling and debuging feature
function makeRadiiPoints(r1, r2)=[
    [0,   0,  0  ],
    [0,   20, r1 ],
    [20,  20, r2 ],
    [20,  0,  0  ]
];

linear_extrude(3){
  // the squre shape being 20 wide, two radii of 10 both fit into the shape (just)
  translate([-25,0,0])polygon(polyRound(makeRadiiPoints(10,10),50));

  //radii are too large and are reduced to fit and will be reduce to 10 and 10
  translate([0,0,0])polygon(polyRound(makeRadiiPoints(30,30),50));

  //radii are too large again and are reduced to fit, but keep their ratios r1 will go from 10 to 4 and r2 will go from 40 to 16
  translate([25,0,0])polygon(polyRound(makeRadiiPoints(10,40),50));

  //mode 2 = no radii limiting
  translate([50,0,0])polygon(polyRound(makeRadiiPoints(15,20),50,mode=2));
}
