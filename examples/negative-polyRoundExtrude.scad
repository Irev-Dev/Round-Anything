// negative polyRoundExtrude example

include <Round-Anything-1.0.4/polyround.scad>

extrudeRadius = 0.8;
extrudeHeight = 2;
tiny = 0.005; // tiny value is used to stop artifacts from planes lining up perfectly

radiiPoints=[
    [-7, -3,  0 ],
    [7,  -3,  0 ],
    [0,  6,   1 ] // top of the triagle is rounded
];
negativeRadiiPoints=[
    [-3, -1,  0 ],
    [3,  -1,  0 ],
    [0,  3,   1 ] // top of the triagle is rounded
];

difference() {
    polyRoundExtrude(radiiPoints,extrudeHeight, extrudeRadius, extrudeRadius,fn=20);
    translate([0,0,-tiny])
        polyRoundExtrude(negativeRadiiPoints,extrudeHeight+2*tiny, -extrudeRadius, -extrudeRadius,fn=20);
}
