// shell2d example

include <Round-Anything-1.0.4/polyround.scad>

module gridpattern(memberW = 4, sqW = 12, iter = 5, r = 3){
	round2d(0, r)rotate([0, 0, 45])translate([-(iter * (sqW + memberW) + memberW) / 2, -(iter * (sqW + memberW) + memberW) / 2])difference(){
		square([(iter) * (sqW + memberW) + memberW, (iter) * (sqW + memberW) + memberW]);
		for (i = [0:iter - 1], j = [0:iter - 1]){
			translate([i * (sqW + memberW) + memberW, j * (sqW + memberW) + memberW])square([sqW, sqW]);
		}
	}
}

radiiPoints=[
  [-4, 0,  1   ],
  [5,  3,  1.5 ],
  [0,  7,  0.1 ],
  [8,  7,  10  ],
  [20, 20, 0.8 ],
  [10, 0,  10  ]
];

linear_extrude(1){
  shell2d(-0.5)polygon(polyRound(radiiPoints,30));
  translate([0,-10,0])shell2d(-0.5){
    polygon(polyRound(radiiPoints,30));
    translate([8,8])gridpattern(memberW = 0.3, sqW = 1, iter = 17, r = 0.2);
  }
}
