// beamChain example 3

include <Round-Anything-1.0.4/polyround.scad>

function beamPoints(r1,r2,rStart=0,rEnd=0)=[
    [0,  0,  rStart],
    [2,  8,  0     ],
    [5,  4,  r1    ],
    [15, 10, r2    ],
    [17, 2,  rEnd  ]
];

// Define more points for a polygon to be atteched to the end of the beam chain
clipP=[
    [16,   1.2, 0  ],
    [16,   0,   0  ],
    [16.5, 0,   0  ],
    [16.5, 1,   0.2],
    [17.5, 1,   0.2],
    [17.5, 0,   0  ],
    [18,   0,   0  ],
    [18,   1.2, 0  ]
];

linear_extrude(1){
  // end hook
  translate([-15,-7*5+3,0]){
    polygon(polyRound(clipP,20));
  }

  // Attached to the end of the beam chain by dividing the beam paths in forward and return and
  // concat other polygon inbetween
  translate([0,-7*6,0]){
    radiiPoints=beamPoints(2,1);
    forwardPath=beamChain(radiiPoints,offset1=0.5,startAngle=-15,mode=2);
    returnPath=revList(beamChain(radiiPoints,offset1=-0.5,startAngle=-15,mode=2));
    entirePath=concat(forwardPath,clipP,returnPath);
    polygon(polyRound(entirePath,20));
  }

  // Add transitioning radii into the end polygong
  translate([0,-7*7-2,0]){
    radiiPoints=beamPoints(2,1,rEnd=3);
    forwardPath=beamChain(radiiPoints,offset1=0.5,startAngle=-15,mode=2);
    returnPath=revList(beamChain(radiiPoints,offset1=-0.5,startAngle=-15,mode=2));
    entirePath=concat(forwardPath,clipP,returnPath);
    polygon(polyRound(entirePath,20));
  }

}
