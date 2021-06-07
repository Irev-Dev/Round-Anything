// beamChain example 4

include <Round-Anything-1.0.4/polyround.scad>

function beamPoints(r1,r2,rStart=0,rEnd=0)=[
    [0,  0,  rStart],
    [2,  8,  0     ],
    [5,  4,  r1    ],
    [15, 10, r2    ],
    [17, 2,  rEnd  ]
];

linear_extrude(1){

  translate([0,-7*9,0]){
    // Define multiple shells from the the one set of points
    for(i=[0:2]){
      polygon(polyRound(beamChain(beamPoints(2,1),offset1=-1+i*0.4, offset2=-1+i*0.4+0.25),20));
    }
  }

}
