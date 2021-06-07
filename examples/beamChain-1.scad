// beamChain example 1

include <Round-Anything-1.0.4/polyround.scad>

function beamPoints(r1,r2,rStart=0,rEnd=0)=[
    [0,  0,  rStart],
    [2,  8,  0     ],
    [5,  4,  r1    ],
    [15, 10, r2    ],
    [17, 2,  rEnd  ]
];

linear_extrude(1){

  // chained lines by themselves
  translate(){
    radiiPoints=beamPoints(0,0);
    polygon(polyRound(beamChain(radiiPoints,offset1=0.02, offset2=-0.02),20));
  }


  // Add some radii to the line transitions
  translate([0,-7,0]){
    radiiPoints=beamPoints(2,1);
    polygon(polyRound(beamChain(radiiPoints,offset1=0.02, offset2=-0.02),20));
  }

  // Give make the lines beams with some thickness
  translate([0,-7*2,0]){
    radiiPoints=beamPoints(2,1);
    polygon(polyRound(beamChain(radiiPoints,offset1=0.5, offset2=-0.5),20));
  }

}
