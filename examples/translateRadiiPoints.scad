// translateRadiiPoints example

include <Round-Anything-1.0.4/polyround.scad>

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
linear_extrude(3)translate([-5,0,0])polygon(polyRound(nutCapture(),20));

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

linear_extrude(3)polygon(polyRound(aSquare,20));
