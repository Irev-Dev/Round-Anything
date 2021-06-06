// polyRoundExtrude example

include <Round-Anything-1.0.4/polyround.scad>

radiiPoints=[
    [10, 0,  10 ],
    [20, 20, 1.1],
    [8,  7,  10 ],
    [0,  7,  0.3],
    [5,  3,  0.1],
    [-4, 0,  1  ]
];
polyRoundExtrude(radiiPoints,2,0.5,-0.8,fn=20);
