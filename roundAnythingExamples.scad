include <polyround.scad>

basicPolyRoundExample();
// polyLineExample();
// parametricPolyRoundExample();
// experimentalParametricPolyRoundExample();
// conflicResolutionExample();
// translateRadiiPointsExample();
// 2dShellExample();
// beamChainExample();
// mirrorPointsExample();
// radiusExtrudeExample();
// polyRoundExtrudeExample();


// testing 
// testGeometries();

module basicPolyRoundExample(){
  // polyLine is a dev helper. Aim is to show the points of the polygon and their order before
  // you're ready to move on to polyRound and a polygon
  radiiPoints=[[-4,0,1],[5,3,1.5],[0,7,0.1],[8,7,10],[20,20,0.8],[10,0,10]];
  polygon(polyRound(radiiPoints,30));
  %translate([0,0,0.3])polygon(getpoints(radiiPoints));//transparent copy of the polgon without rounding
}

module polyLineExample() {
  radiiPoints=[[-4,0,1],[5,3,1.5],[0,7,0.1],[8,7,10],[20,20,0.8],[10,0,10]];
  polyline(polyRound(radiiPoints,3), 0.05);
  translate([0,10,0])
  polyline(radiiPoints, 0.05);
}

module parametricPolyRoundExample() {
  //Example of how a parametric part might be designed with this tool 
  width=20;       height=25;
  slotW=8;        slotH=15;
  slotPosition=8;
  minR=1.5;       farcornerR=6;
  internalR=3;
  // radii points defined in terms of shape dimensions
  points=[
    [0,                   0,              farcornerR],
    [0,                   height,         minR],
    [slotPosition,        height,         minR],
    [slotPosition,        height-slotH,   internalR],
    [slotPosition+slotW,  height-slotH,   internalR],
    [slotPosition+slotW,  height,         minR],
    [width,               height,         minR],
    [width,               0,              minR]
  ];
  translate([-25,0,0]){
    polygon(polyRound(points,5));
  }
  %translate([-25,0,0.2])polygon(getpoints(points));//transparent copy of the polgon without rounding
}

module experimentalParametricPolyRoundExample() {
  //very similar to parametric example, but with some experimental syntax
  width=20;       height=25;
  slotW=8;        slotH=15;
  slotPosition=8;
  minR=1.5;       farcornerR=6;
  internalR=3;
  // radii points defined in terms of shape dimensions
  points2=[
    [0,                   0,              farcornerR],
    ["l",                 height,         minR],
    [slotPosition,        "l",            minR],
    ["l",                 height-slotH,   internalR],
    [slotPosition+slotW,  "l",            internalR],
    ["l",                 height,         minR],
    [width,               "l",            minR],
    ["l",                 height*0.2,     minR],
    [45,                  0,              minR+5,         "ayra"]
  ];
  translate([-50,0,0])polygon(polyRound(points2,5));
  %translate([-50,0,0.2])polygon(getpoints(processRadiiPoints(points2)));//transparent copy of the polgon without rounding
}

module conflicResolutionExample(){
  //example of radii conflict handling and debuging feature
  function makeRadiiPoints(r1, r2)=[[0,0,0],[0,20,r1],[20,20,r2],[20,0,0]];

  // the squre shape being 20 wide, two radii of 10 both fit into the shape (just)
  translate([-25,0,0])polygon(polyRound(makeRadiiPoints(10,10),50));

  //radii are too large and are reduced to fit and will be reduce to 10 and 10
  translate([0,0,0])polygon(polyRound(makeRadiiPoints(30,30),50));

  //radii are too large again and are reduced to fit, but keep their ratios r1 will go from 10 to 4 and r2 will go from 40 to 16
  translate([25,0,0])polygon(polyRound(makeRadiiPoints(10,40),50));

  //mode 2 = no radii limiting
  translate([50,0,0])polygon(polyRound(makeRadiiPoints(12,20),50,mode=2));
}

module translateRadiiPointsExample() {
  // This example shows how a list of points can be used multiple times in the same 
  nutW=5.5;   nutH=3; boltR=1.6;
  minT=2;     minR=0.8;
  function nutCapture(startAndEndRadius=0)=[
    [-boltR,        0,         startAndEndRadius],
    [-boltR,        minT,      0],
    [-nutW/2,       minT,      minR],
    [-nutW/2,       minT+nutH, minR],
    [nutW/2,        minT+nutH, minR],
    [nutW/2,        minT,      minR],
    [boltR,         minT,      0],
    [boltR,         0,         startAndEndRadius],
  ];

  negativeNutCapture=translateRadiiPoints(nutCapture(),tran=[5,0]);
  rotatedNegativeNutCapture=translateRadiiPoints(nutCapture(1),tran=[20,5],rot=90);
  aSquare=concat(
    [[0,0,0]],
    negativeNutCapture,
    [[20,0,0]],
    rotatedNegativeNutCapture,
    [[20,10,0]],
    [[0,10,0]]
  );
  polygon(polyRound(aSquare,20));
  translate([-5,0,0])polygon(polyRound(nutCapture(),20));
}

module 2dShellExample(){
  radiiPoints=[[-4,0,1],[5,3,1.5],[0,7,0.1],[8,7,10],[20,20,0.8],[10,0,10]];
  linear_extrude(1)shell2d(-0.5)polygon(polyRound(radiiPoints,30));
  translate([0,-10,0])linear_extrude(1)shell2d(-0.5){
    polygon(polyRound(radiiPoints,30));
    translate([8,8])gridpattern(memberW = 0.3, sqW = 1, iter = 17, r = 0.2);
  }
}

module beamChainExample(){
  function beamPoints(r1,r2,rStart=0,rEnd=0)=[[0,0,rStart],[2,8,0],[5,4,r1],[15,10,r2],[17,2,rEnd]];

  // chained lines by themselves
  translate([0,0,0]){
    radiiPoints=beamPoints(0,0);
    for(i=[0: len(radiiPoints)-1]){color("red")translate([radiiPoints[i].x,radiiPoints[i].y,0])cylinder(d=0.2, h=1);}
    linear_extrude(1)polygon(polyRound(beamChain(radiiPoints,offset1=0.02, offset2=-0.02),20));
  }
  

  // Add some radii to the line transitions
  translate([0,-7,0]){
    radiiPoints=beamPoints(2,1);
    for(i=[0: len(radiiPoints)-1]){color("red")translate([radiiPoints[i].x,radiiPoints[i].y,0])cylinder(d=0.2, h=1);}
    linear_extrude(1)polygon(polyRound(beamChain(radiiPoints,offset1=0.02, offset2=-0.02),20));
  }
  
  // Give make the lines beams with some thickness
  translate([0,-7*2,0]){
    radiiPoints=beamPoints(2,1);
    linear_extrude(1)polygon(polyRound(beamChain(radiiPoints,offset1=0.5, offset2=-0.5),20));
  }

  // Add an angle to the start of the beam
  translate([0,-7*3,0]){
    radiiPoints=beamPoints(2,1);
    linear_extrude(1)polygon(polyRound(beamChain(radiiPoints,offset1=0.5, offset2=-0.5, startAngle=45),20));
  }

  // Put a negative radius at the start for transationing to a flat surface
  translate([0,-7*4,0]){
    radiiPoints=beamPoints(2,1,rStart=-0.7);
    linear_extrude(1)polygon(polyRound(beamChain(radiiPoints,offset1=0.5, offset2=-0.5, startAngle=45),20));
  }

  // Define more points for a polygon to be atteched to the end of the beam chain
  clipP=[[16,1.2,0],[16,0,0],[16.5,0,0],[16.5,1,0.2],[17.5,1,0.2],[17.5,0,0],[18,0,0],[18,1.2,0]];
  translate([-15,-7*5+3,0]){
    for(i=[0:len(clipP)-1]){color("red")translate([clipP[i].x,clipP[i].y,0])cylinder(d=0.2, h=1);}
    linear_extrude(1)polygon(polyRound(clipP,20));
  }

  // Attached to the end of the beam chain by dividing the beam paths in forward and return and
  // concat other polygon inbetween
  translate([0,-7*6,0]){
    radiiPoints=beamPoints(2,1);
    forwardPath=beamChain(radiiPoints,offset1=0.5,startAngle=-15,mode=2);
    returnPath=revList(beamChain(radiiPoints,offset1=-0.5,startAngle=-15,mode=2));
    entirePath=concat(forwardPath,clipP,returnPath);
    linear_extrude(1)polygon(polyRound(entirePath,20));
  }

  // Add transitioning radii into the end polygong
  translate([0,-7*7-2,0]){
    radiiPoints=beamPoints(2,1,rEnd=3);
    forwardPath=beamChain(radiiPoints,offset1=0.5,startAngle=-15,mode=2);
    returnPath=revList(beamChain(radiiPoints,offset1=-0.5,startAngle=-15,mode=2));
    entirePath=concat(forwardPath,clipP,returnPath);
    linear_extrude(1)polygon(polyRound(entirePath,20));
  }

  // Define multiple shells from the the one set of points
  translate([0,-7*9,0]){
    radiiPoints=beamPoints(2,1,rEnd=3);
    for(i=[0:2]){linear_extrude(1)polygon(polyRound(beamChain(radiiPoints,offset1=-1+i*0.4, offset2=-1+i*0.4+0.25),20));}
  }
}

module mirrorPointsExample(){
  function points(endR=0)=[[0,0,0],[2,8,0],[5,4,3],[15,10,0.5],[10,2,endR]];
  mirroredPoints=mirrorPoints(points(0),0,[1,0]);
  polygon(polyRound(mirroredPoints,20));
  mirroredPoints2=mirrorPoints(points(7),0,[1,0]);
  translate([0,-20,0])polygon(polyRound(mirroredPoints2,20));
}

module radiusExtrudeExample(){
  radiiPoints=[[-4,0,1],[5,3,1.5],[0,7,0.1],[8,7,10],[20,20,0.8],[10,0,10]];
  extrudeWithRadius(3,0.5,0.5,50)polygon(polyRound(radiiPoints,30));
  #translate([7,4,3])extrudeWithRadius(3,-0.5,0.95,50)circle(1,$fn=30);
}

module polyRoundExtrudeExample(){
  radiiPoints=[[10,0,10],[20,20,1.1],[8,7,10],[0,7,0.3],[5,3,0.1],[-4,0,1]];
  polyRoundExtrude(radiiPoints,2,0.5,-0.8,fn=8);
}

module gridpattern(memberW = 4, sqW = 12, iter = 5, r = 3){
	round2d(0, r)rotate([0, 0, 45])translate([-(iter * (sqW + memberW) + memberW) / 2, -(iter * (sqW + memberW) + memberW) / 2])difference(){
		square([(iter) * (sqW + memberW) + memberW, (iter) * (sqW + memberW) + memberW]);
		for (i = [0:iter - 1], j = [0:iter - 1]){
			translate([i * (sqW + memberW) + memberW, j * (sqW + memberW) + memberW])square([sqW, sqW]);
		}
	}
}


module testGeometries() {
  // Check these shapes preview (plus "thrown together") and render correctly with each PR
  points = [
    [0, 10, 5],
    [10, 0, 5],
    [0, -10, 5],
    [-10, 0, 5],
  ];
  reversedPoints = [
    [-10, 0, 5],
    [0, -10, 5],
    [10, 0, 5],
    [0, 10, 5],
  ];
  polyRoundExtrudeTestShape(points);
  translate([0,20,0])polyRoundExtrudeTestShape(reversedPoints);

  // Bug report submitted by @lopisan in issue #16, similar to #11, geometry breaks with 90 degree angles
  didBreakWhen0=0;
  issue16pointsa=[[0, 0, 0], [0+didBreakWhen0, 10, 0], [10, 10+didBreakWhen0, 0]];
  translate([20,0,0])linear_extrude(1)polygon(polyRound( beamChain(issue16pointsa, offset1=1, offset2=-1), 30));
  
  didBreakWhen0b=1e-6;
  issue16pointsb=[[0, 0, 0], [0+didBreakWhen0b, 10, 0], [10, 10+didBreakWhen0b, 0]];
  translate([20,15,0])linear_extrude(1)polygon(polyRound( beamChain(issue16pointsb, offset1=1, offset2=-1), 30));

}

module polyRoundExtrudeTestShape(points) {
  // make sure no faces are inverted
  difference() {
    translate([0, 0, -2.5]) polyRoundExtrude(points,r1=-1,r2=1);
    sphere(d=9);
    translate([0,0,7])sphere(d=9);
  }
}