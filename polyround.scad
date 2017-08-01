// Library: round-anything
// Version: 1.0
// Author: IrevDev
// Contributors: TLC123
// Copyright: 2017
// License: GPL 3


//uncomment to see the examples
examples();

module examples(){
    //Example of how a parametric part might be designed with this tool 
    width=20;       height=25;
    slotW=8;        slotH=15;
    slotPosition=8;
    minR=1.5;       farcornerR=6;
    internalR=3;
    points=[[0,0,minR],[0,height,minR],[slotPosition,height,minR],[slotPosition,height-slotH,internalR],
    [slotPosition+slotW,height-slotH,internalR],[slotPosition+slotW,height,minR],[width,height,minR],[width,0,farcornerR]];
    translate([-25,0,0])polygon(polyRound(points,5));
    %translate([-25,0,0.2])polygon(getpoints(points));//transparent copy of the polgon without rounding
    
    //Example of features 2
    //     1        2       3       4          5        6     
    b=[[-4,0,1],[5,3,1.5],[0,7,0],[8,7,10],[20,20,1],[10,0,10]]; //points
    echo("example 2", polyRound(b,1));
   // polygon(polyRound(b,30));/*polycarious() will make the same shape but doesn't have radii conflict handling*/ //
 polygon(polycarious(b,30));
    %translate([0,0,0.2])polygon(getpoints(b));//transparent copy of the polgon without rounding

    
    //Example of features 3
    //    1        2        3        4         5       6
    p=[[0,0,1.2],[0,20,1],[15,15,1],[3,10,3],[15,0,1],[6,2,10]];//points
	  a=polyRound(p,5);
    translate([25,0,0])polygon(a);
    %translate([25,0,0.2])polygon(getpoints(p));//transparent copy of the polgon without rounding
		
		//example of radii conflict handling and debuging feature
		r1a=10;			r1b=10;
		r2a=30;			r2b=30;
		r3a=10;			r3b=40;
		c1=[[0,0,0],[0,20,r1a],[20,20,r1b],[20,0,0]];//both radii fit and don't need to be changed
		translate([-25,-25,0])polygon(polyRound(c1,8));
		echo("c1 debug",polyRound(c1,8,debug=1));// [0,0,0,0] all zeros indicates none of the radii were reduced
   
		c2=[[0,0,0],[0,20,r2a],[20,20,r2b],[20,0,0]];//radii are too large and are reduced to fit
		translate([0,-25,0])polygon(polyRound(c2,8));
		echo("c2 debug",polyRound(c2,8,debug=1));// [0,-20,-20,0] 2nd and 3rd radii reduced by 20mm i.e. from 30 to 10mm radius
   
		c3=[[0,0,0],[0,20,r3a],[20,20,r3b],[20,0,0]];//radii are too large again and are reduced to fit, but keep their ratios
		translate([25,-25,0])polygon(polyRound(c3,8));
		echo("c3 debug",polyRound(c3,8,debug=1));// [0,-6,-24,0] 2nd and 3rd radii reduced by 6 and 24mm respectively 
		//resulting in radii of 4 and 16mm, 
		//notice the ratio from the orginal radii stays the same r3a/r3b = 10/40 = 4/16
		
		//example of rounding random points, this has no current use but is a good demonstration
		random=[for(i=[0:20])[rnd(0,50),rnd(0,50),/*rnd(0,30)*/1000]];
		R =polyRound(random,7);
		translate([-25,25,0])polyline(R);
		
		//example of different modes of the CentreN2PointsArc() function 0=shortest arc, 1=longest arc, 2=CW, 3=CCW
		p1=[0,5];p2=[10,5];centre=[5,0];
    translate([60,0,0]){
    color("green")polygon(CentreN2PointsArc(p1,p2,centre,0,20));//draws the shortest arc
    color("cyan")polygon(CentreN2PointsArc(p1,p2,centre,1,20));//draws the longest arc
    }
    translate([75,0,0]){
    color("purple")polygon(CentreN2PointsArc(p1,p2,centre,2,20));//draws the arc CW (which happens to be the short arc)
    color("red")polygon(CentreN2PointsArc(p2,p1,centre,2,20));//draws the arc CW but p1 and p2 swapped order resulting in the long arc being drawn
    }
		
		radius=6;
		radiipoints=[[0,0,0],[10,20,radius],[20,0,0]];
		tangentsNcen=round3points(radiipoints);
		translate([100,0,0]){
		    for(i=[0:2]){
		        color("red")translate(getpoints(radiipoints)[i])circle(1);//plots the 3 input points
		        color("cyan")translate(tangentsNcen[i])circle(1);//plots the two tangent poins and the circle centre
				}
				translate([tangentsNcen[2][0],tangentsNcen[2][1],-0.2])circle(r=radius,$fn=25);//draws the cirle
				%polygon(getpoints(radiipoints));//draws a polygon
		}
}

function polyRound(radiipoints,fn=5,debug=0)=
		let(p=getpoints(radiipoints)) //make list of coordinates without radii
		let(Lp=len(p))
		//remove the middle point of any three colinear points
		let(newrp=[for(i=[0:len(p)-1]) if(isColinear(p[wrap(i-1,Lp)],p[wrap(i+0,Lp)],p[wrap(i+1,Lp)])==0)radiipoints[wrap(i+0,Lp)] ])
		let(temp=[for(i=[0:len(newrp)-1]) //for each point in the radii array
				let(the5points=[for(j=[-2:2])newrp[wrap(i+j,len(newrp))]])//collect 5 radii points
                let(temp2=round5points(the5points,fn,debug))
								debug>0?temp2:newrp[i][2]==0?[[newrp[i][0],newrp[i][1]]]: //return the original point if the radius is 0
                CentreN2PointsArc(temp2[0],temp2[1],temp2[2],0,fn) //return the arc if everything is normal
		])
		[for (a = temp) for (b = a) b];//flattern and return the array

function round5points(rp,fn,debug=0)=
		rp[2][2]==0&&debug==0?[[rp[2][0],rp[2][1]]]://return the middle point if the radius is 0
		rp[2][2]==0&&debug==1?0://if debug is enabled and the radius is 0 return 0
		let(p=getpoints(rp)) //get list of points
		let(r=[for(i=[1:3]) rp[i][2]])//get the centre 3 radii
    //start by determining what the radius should be at point 3
    //find angles at points 2 , 3 and 4
    let(a2=cosineRuleAngle(p[0],p[1],p[2]))
    let(a3=cosineRuleAngle(p[1],p[2],p[3]))
    let(a4=cosineRuleAngle(p[2],p[3],p[4]))
    //find the distance between points 2&3 and between points 3&4
    let(d23=pointDist(p[1],p[2]))
    let(d34=pointDist(p[2],p[3]))
    //find the radius factors
    let(F23=(d23*tan(a2/2)*tan(a3/2))/(r[0]*tan(a3/2)+r[1]*tan(a2/2)))
    let(F34=(d34*tan(a3/2)*tan(a4/2))/(r[1]*tan(a4/2)+r[2]*tan(a3/2)))
    let(newR=min(r[1],F23*r[1],F34*r[1]))//use the smallest radius
		//now that the radius has been determined, find tangent points and circle centre
		let(tangD=newR/tan(a3/2))//distance to the tangent point from p3
    let(circD=newR/sin(a3/2))//distance to the circle centre from p3
		//find the angle from the p3
		let(an23=getAngle(p[1],p[2]))//angle from point 3 to 2
		let(an34=getAngle(p[3],p[2]))//angle from point 3 to 4
		//find tangent points
		let(t23=[p[2][0]-cos(an23)*tangD,p[2][1]-sin(an23)*tangD])//tangent point between points 2&3
		let(t34=[p[2][0]-cos(an34)*tangD,p[2][1]-sin(an34)*tangD])//tangent point between points 3&4
		//find circle centre
		let(tmid=getMidpoint(t23,t34))//midpoint between the two tangent points
		let(anCen=getAngle(tmid,p[2]))//angle from point 3 to circle centre
		let(cen=[p[2][0]-cos(anCen)*circD,p[2][1]-sin(anCen)*circD])//circle center by offseting from point 3
    //determine the direction of rotation
		debug==0?//if debug in disabled return arc (default)
        [t23,t34,cen]
		:(newR-r[1]);

function polycarious(radiipoints,fn=5)=
		let(p=getpoints(radiipoints)) 
		let(newrp=[for(i=[0:len(p)-1]) 
		 		let(the3points=[for(j=[-1:1]) p[wrap(i+j,len(p))]])
				if(isColinear(the3points[0],the3points[1],the3points[2])==0) radiipoints[wrap(i+0,len(p))] 
	  ])
		let(temp=[for(i=[0:len(newrp)-1]) 
				let(the3points=[for(j=[-1:1]) newrp[wrap(i+j,len(newrp))]])//collect 3 points
				let(temp2=round3points(the3points,fn))
            newrp[i][2]==0?[[newrp[i][0],newrp[i][1]]]: //return the original point if the radius is 0
            CentreN2PointsArc(temp2[0],temp2[1],temp2[2],0,fn) //return the arc if everything is normal
				])
		[for (a = temp) for (b = a) b]; //flattern and return the array

function round3points(rp,fn)=
    rp[1][2]==0?[[rp[1][0],rp[1][1]]]://return the middle point if the radius is 0
		let(p=getpoints(rp)) //get list of points
		let(r=rp[1][2])//get the centre 3 radii
    let(ang=cosineRuleAngle(p[0],p[1],p[2]))//angle between the lines
    //now that the radius has been determined, find tangent points and circle centre
		let(tangD=r/tan(ang/2))//distance to the tangent point from p2
    let(circD=r/sin(ang/2))//distance to the circle centre from p2
		//find the angles from the p2 with respect to the postitive x axis
		let(a12=getAngle(p[0],p[1]))//angle from point 2 to 1
		let(a23=getAngle(p[2],p[1]))//angle from point 2 to 3
		//find tangent points
		let(t12=[p[1][0]-cos(a12)*tangD,p[1][1]-sin(a12)*tangD])//tangent point between points 1&2
		let(t23=[p[1][0]-cos(a23)*tangD,p[1][1]-sin(a23)*tangD])//tangent point between points 2&3
    //find circle centre
		let(tmid=getMidpoint(t12,t23))//midpoint between the two tangent points
		let(angCen=getAngle(tmid,p[1]))//angle from point 2 to circle centre
		let(cen=[p[1][0]-cos(angCen)*circD,p[1][1]-sin(angCen)*circD])//circle center by offseting from point 2 
		[t12,t23,cen];
        //CentreN2PointsArc(t12,t23,cen,0,fn);
        
function CentreN2PointsArc(p1,p2,cen,mode=0,fn)=
    /* This function plots an arc from p1 to p2 with fn increments using the cen as the centre of the arc.
    the mode determines how the arc is plotted
    mode==0, shortest arc possible 
    mode==1, longest arc possible
    mode==2, plotted clockwise
    mode==3, plotted counter clockwise
    */
    //determine the direction of rotation
    let(e1=(cen[0]-p1[0])*(cen[1]+p1[1]))//edge 1
    let(e2=(p2[0]-cen[0])*(p2[1]+cen[1]))//edge 2
    let(e3=(p1[0]-p2[0])*(p1[1]+p2[1]))//edge 3
    let(CWorCCW=(e1+e2+e3)/abs(e1+e2+e3))//rotation of the three points cw or ccw?
    //determine the arc angle depending on the mode
    let(p1p2Angle=cosineRuleAngle(p2,cen,p1))
    let(arcAngle=
        mode==0?p1p2Angle:
        mode==1?p1p2Angle-360:
        mode==2&&CWorCCW==-1?p1p2Angle:
        mode==2&&CWorCCW== 1?p1p2Angle-360:
        mode==3&&CWorCCW== 1?p1p2Angle:
        mode==3&&CWorCCW==-1?p1p2Angle-360:
        cosineRuleAngle(p2,cen,p1))
    let(r=pointDist(p1,cen))//determine the radius
	let(p1Angle=getAngle(cen,p1))//angle of line 1
    [for(i=[0:fn]) [cos(p1Angle+(arcAngle/fn)*i*CWorCCW)*r+cen[0],sin(p1Angle+(arcAngle/fn)*i*CWorCCW)*r+cen[1]]];
 
function invtan(run,rise)=
    let(a=abs(atan(rise/run)))
    rise==0&&run>0?0:rise>0&&run>0?a:rise>0&&run==0?90:rise>0&&run<0?180-a:rise==0&&run<0?180:rise<0&&run<0?a+180:rise<0&&run==0?270:rise<0&&run>0?360-a:"error";

function cosineRuleAngle(p1,p2,p3)=
    let(p12=abs(pointDist(p1,p2)))
    let(p13=abs(pointDist(p1,p3)))
    let(p23=abs(pointDist(p2,p3)))
    acos((sq(p23)+sq(p12)-sq(p13))/(2*p23*p12));

function sq(x)=x*x;
function getGradient(p1,p2)=(p2[1]-p1[1])/(p2[0]-p1[0]);
function getAngle(p1,p2)=invtan(p2[0]-p1[0],p2[1]-p1[1]);
function getMidpoint(p1,p2)=[(p1[0]+p2[0])/2,(p1[1]+p2[1])/2]; //returns the midpoint of two points
function pointDist(p1,p2)=sqrt(abs(sq(p1[0]-p2[0])+sq(p1[1]-p2[1]))); //returns the distance between two points
function isColinear(p1,p2,p3)=getGradient(p1,p2)==getGradient(p2,p3)?1:0;//return 1 if 3 points are colinear

 module polyline(p) {for(i=[0:max(0,len(p)-1)])line(p[i],p[wrap(i+1,len(p) )]);
} // polyline plotter

module line(p1, p2 ,width=0.3) 
{ // single line plotter
    hull() {
        translate(p1) sphere(width);
        translate(p2) sphere(width);
    }
}

function getpoints(p)=[for(i=[0:len(p)-1])[p[i].x,p[i].y]];// gets [x,y]list of[x,y,r]list
function wrap(x,x_max=1,x_min=0) = (((x - x_min) % (x_max - x_min)) + (x_max - x_min)) % (x_max - x_min) + x_min; // wraps numbers inside boundaries
function rnd(a = 1, b = 0, s = []) = 
  s == [] ? 
   (rands(min(a, b), max(   a, b), 1)[0]) 
  : 
   (rands(min(a, b), max(a, b), 1, s)[0])
  ; // nice rands wrapper 
