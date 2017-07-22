// Library: round-anything
// Version: 1.0
// Author: IrevDev
// Copyright: 2017
// License: GPL 3


//callExamples(); //uncomment to view examples

module callExamples(){
    //Example of how a parametric part might be designed with this tool 
    width=20;       height=25;
    slotW=8;        slotH=15;
    slotPosition=8;
    minR=1.5;       farcornerR=6;
    internalR=3;
    points=[[0,0],[0,height],[slotPosition,height],[slotPosition,height-slotH],
    [slotPosition+slotW,height-slotH],[slotPosition+slotW,height],[width,height],[width,0]];
    radiuses=[minR,minR,minR,internalR,internalR,minR,minR,farcornerR];
    translate([-30,0,0])polygon(polyRound(points,radiuses));
    %translate([-30,0,0.2])polygon(points);
    
    //Example of features 2
    //   1     2     3      4      5       6     
    b=[[-5,0],[5,3],[0,7],[8,7],[20,20],[10,0]]; //points
    br=[1,     1.5,   0,   10,     1,     10]; //radiuses
    polygon(polyRound(b,br,50));
    %translate([0,0,0.2])polygon(b);
    
    
    //Example of features 3
    //   1     2       3      4       5     6
    p=[[0,0],[0,20],[15,15],[3,10],[15,0],[6,2]];//points
    pr=[1,     1,      0,     3,      1,   10];//radiuses
    translate([25,0,0])polygon(polyRound(p,pr,3));
    %translate([25,0,0.2])polygon(p);
}


function polyRound(p,r,fn=5)=
    let(p2=concat([p[len(p)-1]],p,[p[0]]))//turns the orginal array in (last element, array, first element) since the points are processed 3 at a time.
    let(temp=[for(i=[0:len(p)-1]) r[i]<=0?[p[i]]:round3points(p2[i],p2[i+1],p2[i+2],r[i],fn)])//passes three points at a time to polyRound()
    //temp ends up being a 3 dimensional array where each arc is grouped together, so the below code breaks it up and turns it back into a 2d array, ie list of coordinates (is there a better way of doing this? a way to stop it from becomeing a 3d array in the first place?
    [for(i=[0:len(temp)-1]) for(j=[0:len(temp[i])-1]) temp[i][j]];

function round3points(p1,p2,p3,r,fn)=
    
    let(ang=cosineRuleAngle(p1,p2,p3))//angle between the lines
    let(tangD=r/tan(ang/2))//distance to the tangent point from p2
    let(circD=r/sin(ang/2))//distance to the circle centre from p2
    let(a12=abs(atan(getGradient(p1,p2))))//angle of line 1
    let(a23=abs(atan(getGradient(p2,p3))))//angle of line 2
    
    let(vec21=p1-p2)//vector from p2 to p1
    let(vec23=p3-p2)//vector from p2 to p3
    let(dir21x=vec21[0]==0?0:vec21[0]/abs(vec21[0]))//tangent along line p2 to p1 x polerisation. Returns 1,-1 or 0
    let(dir21y=vec21[1]==0?0:vec21[1]/abs(vec21[1]))//tangent along line p2 to p1 y polerisation. Returns 1,-1 or 0
    let(dir23x=vec23[0]==0?0:vec23[0]/abs(vec23[0]))//tangent along line p3 to p1 x polerisation. Returns 1,-1 or 0
    let(dir23y=vec23[1]==0?0:vec23[1]/abs(vec23[1]))//tangent along line p3 to p1 Y polerisation. Returns 1,-1 or 0
    
    let(t12=[p2[0]+dir21x*cos(a12)*tangD,p2[1]+dir21y*sin(a12)*tangD])//tangent point along line p2 to p2 by offseting from p2
    let(t23=[p2[0]+dir23x*cos(a23)*tangD,p2[1]+dir23y*sin(a23)*tangD])//tangent point along line p2 to p3 by offseting from p2
    
    let(vec_=getMidpoint(t12,t23)-p2)//vector from P1 to the midpoint of the two tangents
    let(dirx_=vec_[0]==0?0:vec_[0]/abs(vec_[0]))//circle center point x polerisation
    let(diry_=vec_[1]==0?0:vec_[1]/abs(vec_[1]))//circle center point y polerisation
    let(a_=abs(atan(getGradient(getMidpoint(t12,t23),p2))))//angle of line from tangent midpoints to p2
    let(cen=[p2[0]+dirx_*cos(a_)*circD,p2[1]+diry_*sin(a_)*circD])//circle center by offseting from p2
    
    let(e1=(p2[0]-p1[0])*(p2[1]+p1[1]))//edge 1
    let(e2=(p3[0]-p2[0])*(p3[1]+p2[1]))//edge 2
    let(e3=(p1[0]-p3[0])*(p1[1]+p3[1]))//edge 3
    let(CWorCCW=(e1+e2+e3)/abs(e1+e2+e3))//rotation of the three points cw or ccw?
    CentreN2PointsArc(t12,t23,cen,CWorCCW,fn);
        
function CentreN2PointsArc(p1,p2,cen,CWorCCW,fn)=
    let(r=pointDist(p1,cen))
    let(CircA1=invtan(p1[0]-cen[0],p1[1]-cen[1]))//angle of line 1
    let(CircA2=cosineRuleAngle(p2,cen,p1))//angle between the lines
    [for(i=[0:fn]) [cos(CircA1+(CircA2/fn)*-i*CWorCCW)*r+cen[0],sin(CircA1+(CircA2/fn)*-i*CWorCCW)*r+cen[1]]];
 
function invtan(run,rise)=
    let(a=abs(atan(rise/run)))
    rise==0&&run>0?0:rise>0&&run>0?a:rise>0&&run==0?90:rise>0&&run<0?180-a:rise==0&&run<0?180:rise<0&&run<0?a+180:rise<0&&run==0?270:rise<0&&run>0?360-a:"error";

function cosineRuleAngle(p1,p2,p3)=
    let(p12=abs(pointDist(p1,p2)))
    let(p13=abs(pointDist(p1,p3)))
    let(p23=abs(pointDist(p2,p3)))
    acos((sq(p23)+sq(p12)-sq(p13))/(2*p23*p12));
    
function getIntersect(m1,m2,k1,k2)=
    let(x=(k2-k1)/(m1-m2))
    let(y=m1*x+k1)
    [x,y];

function sq(x)=x*x;
function getGradient(p1,p2)=(p2[1]-p1[1])/(p2[0]-p1[0]);
function getConstant(p,m)=p[1]-m*p[0];
function getMidpoint(p1,p2)=[(p1[0]+p2[0])/2,(p1[1]+p2[1])/2];
function pointDist(p1,p2)=sqrt(abs(sq(p1[0]-p2[0])+sq(p1[1]-p2[1])));
    
