// beamChain example 2

include <Round-Anything-1.0.4/polyround.scad>

function beamPoints(r1,r2,rStart=0,rEnd=0)=[
    [0,  0,  rStart],
    [2,  8,  0     ],
    [5,  4,  r1    ],
    [15, 10, r2    ],
    [17, 2,  rEnd  ]
];

linear_extrude(1){

  // Add an angle to the start of the beam
  translate([0,-7*3,0]){
    radiiPoints=beamPoints(2,1);
    polygon(polyRound(beamChain(radiiPoints,offset1=0.5, offset2=-0.5, startAngle=45),20));
  }

  // Put a negative radius at the start for transationing to a flat surface
  translate([0,-7*4,0]){
    radiiPoints=beamPoints(2,1,rStart=-0.7);
    polygon(polyRound(beamChain(radiiPoints,offset1=0.5, offset2=-0.5, startAngle=45),20));
  }

}
