// Library: round-anything
// Version: 1.0
// Author: IrevDev
// Contributors: TLC123
// Copyright: 2017
// License: GPL 3


    
//examples();
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
    b=[[-4,0,1],[5,3,1.5],[0,7,0.1],[8,7,10],[20,20,0.8],[10,0,10]]; //points
    polygon(polyRound(b,30));/*polycarious() will make the same shape but doesn't have radii conflict handling*/ //polygon(polycarious(b,30));
    %translate([0,0,0.3])polygon(getpoints(b));//transparent copy of the polgon without rounding
       
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
        r4a=15;         r4b=20;
		c1=[[0,0,0],[0,20,r1a],[20,20,r1b],[20,0,0]];//both radii fit and don't need to be changed
		translate([-25,-30,0])polygon(polyRound(c1,8));
		echo(str("c1 debug= ",polyRound(c1,8,mode=1)," all zeros indicates none of the radii were reduced")); 
   
		c2=[[0,0,0],[0,20,r2a],[20,20,r2b],[20,0,0]];//radii are too large and are reduced to fit
		translate([0,-30,0])polygon(polyRound(c2,8));
		echo(str("c2 debug= ",polyRound(c2,8,mode=1)," 2nd and 3rd radii reduced by 20mm i.e. from 30 to 10mm radius"));
   
		c3=[[0,0,0],[0,20,r3a],[20,20,r3b],[20,0,0]];//radii are too large again and are reduced to fit, but keep their ratios
		translate([25,-30,0])polygon(polyRound(c3,8));
		echo(str("c3 debug= ",polyRound(c3,8,mode=1)," 2nd and 3rd radii reduced by 6 and 24mm respectively"));
		//resulting in radii of 4 and 16mm, 
		//notice the ratio from the orginal radii stays the same r3a/r3b = 10/40 = 4/16
        c4=[[0,0,0],[0,20,r4a],[20,20,r4b],[20,0,0]];//radii are too large again but not corrected this time
		translate([50,-30,0])polygon(polyRound(c4,8,mode=2));//mode 2 = no radii limiting
        
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
        
    //for(i=[0:len(b2)-1]) translate([b2[i].x,b2[i].y,2])#circle(0.2);
    ex=[[0,0,-1],[2,8,0],[5,4,3],[15,10,0.5],[10,2,1]];
    translate([15,-50,0]){
        ang=55;
        minR=0.2;
        rotate([0,0,ang+270])translate([0,-5,0])square([10,10],true);
        clipP=[[9,1,0],[9,0,0],[9.5,0,0],[9.5,1,0.2],[10.5,1,0.2],[10.5,0,0],[11,0,0],[11,1,0]];
        a=RailCustomiser(ex,o1=0.5,minR=minR,a1=ang-90,a2=0,mode=2);
        b=revList(RailCustomiser(ex,o1=-0.5,minR=minR,a1=ang-90,a2=0,mode=2));
        points=concat(a,clipP,b);
        points2=concat(ex,clipP,b);
        polygon(polyRound(points,20));
        //%polygon(polyRound(points2,20));
    }
    
    //the following exapmle shows how the offsets in RailCustomiser could be used to makes shells
    translate([-20,-60,0]){
        for(i=[-9:0.5:1])polygon(polyRound(RailCustomiser(ex,o1=i-0.4,o2=i,minR=0.1),20));
    }
    
    // This example shows how a list of points can be used multiple times in the same 
    nutW=5.5;   nutH=3; boltR=1.6;
    minT=2;     minR=0.8;
    nutCapture=[
        [-boltR,        0,         0],
        [-boltR,        minT,      0],
        [-nutW/2,       minT,      minR],
        [-nutW/2,       minT+nutH, minR],
        [nutW/2,        minT+nutH, minR],
        [nutW/2,        minT,      minR],
        [boltR,         minT,      0],
        [boltR,         0,         0],
    ];
    aSquare=concat(
    [[0,0,0]],
    moveRadiiPoints(nutCapture,tran=[5,0],rot=0),
    [[20,0,0]],
    moveRadiiPoints(nutCapture,tran=[20,5],rot=90),
    [[20,10,0]],
    [[0,10,0]]
    );
    echo(aSquare);
    translate([40,-60,0]){
        polygon(polyRound(aSquare,20));
        translate([10,12,0])polygon(polyRound(nutCapture,20));
    }        
}
{function polyRound(radiipoints,fn=5,mode=0)=
/*  Takes a list of radii points of the format [x,y,radius] and rounds each point
    with fn resolution
    mode=0 - automatic radius limiting - DEFAULT
    mode=1 - Debug, output radius reduction for automatic radius limiting
    mode=2 - No radius limiting*/
		let(
        getpoints=mode==2?1:2,
        p=getpoints(radiipoints), //make list of coordinates without radii
		Lp=len(p),
		//remove the middle point of any three colinear points
		newrp=[for(i=[0:len(p)-1]) if(isColinear(p[wrap(i-1,Lp)],p[wrap(i+0,Lp)],p[wrap(i+1,Lp)])==0||p[wrap(i+0,Lp)].z!=0)radiipoints[wrap(i+0,Lp)] ],
		temp=[for(i=[0:len(newrp)-1]) //for each point in the radii array
            let(
            thepoints=[for(j=[-getpoints:getpoints])newrp[wrap(i+j,len(newrp))]],//collect 5 radii points
            temp2=mode==2?round3points(thepoints,fn):round5points(thepoints,fn,mode)
            )
			mode==1?temp2:newrp[i][2]==0?[[newrp[i][0],newrp[i][1]]]: //return the original point if the radius is 0
            CentreN2PointsArc(temp2[0],temp2[1],temp2[2],0,fn) //return the arc if everything is normal
            ]
        )
		[for (a = temp) for (b = a) b];}//flattern and return the array
{function round5points(rp,fn,debug=0)=
	rp[2][2]==0&&debug==0?[[rp[2][0],rp[2][1]]]://return the middle point if the radius is 0
	rp[2][2]==0&&debug==1?0://if debug is enabled and the radius is 0 return 0
	let(
    p=getpoints(rp), //get list of points
    r=[for(i=[1:3]) rp[i][2]],//get the centre 3 radii
    //start by determining what the radius should be at point 3
    //find angles at points 2 , 3 and 4
    a2=cosineRuleAngle(p[0],p[1],p[2]),
    a3=cosineRuleAngle(p[1],p[2],p[3]),
    a4=cosineRuleAngle(p[2],p[3],p[4]),
    //find the distance between points 2&3 and between points 3&4
    d23=pointDist(p[1],p[2]),
    d34=pointDist(p[2],p[3]),
    //find the radius factors
    F23=(d23*tan(a2/2)*tan(a3/2))/(r[0]*tan(a3/2)+r[1]*tan(a2/2)),
    F34=(d34*tan(a3/2)*tan(a4/2))/(r[1]*tan(a4/2)+r[2]*tan(a3/2)),
    newR=min(r[1],F23*r[1],F34*r[1]),//use the smallest radius
	//now that the radius has been determined, find tangent points and circle centre
	tangD=newR/tan(a3/2),//distance to the tangent point from p3
    circD=newR/sin(a3/2),//distance to the circle centre from p3
	//find the angle from the p3
	an23=getAngle(p[1],p[2]),//angle from point 3 to 2
	an34=getAngle(p[3],p[2]),//angle from point 3 to 4
	//find tangent points
	t23=[p[2][0]-cos(an23)*tangD,p[2][1]-sin(an23)*tangD],//tangent point between points 2&3
	t34=[p[2][0]-cos(an34)*tangD,p[2][1]-sin(an34)*tangD],//tangent point between points 3&4
	//find circle centre
	tmid=getMidpoint(t23,t34),//midpoint between the two tangent points
	anCen=getAngle(tmid,p[2]),//angle from point 3 to circle centre
	cen=[p[2][0]-cos(anCen)*circD,p[2][1]-sin(anCen)*circD]
    )
    //circle center by offseting from point 3
    //determine the direction of rotation
	debug==1?//if debug in disabled return arc (default)
    (newR-r[1]):
	[t23,t34,cen];}
{function round3points(rp,fn)=
    rp[1][2]==0?[[rp[1][0],rp[1][1]]]://return the middle point if the radius is 0
	let(
    p=getpoints(rp), //get list of points
	r=rp[1][2],//get the centre 3 radii
    ang=cosineRuleAngle(p[0],p[1],p[2]),//angle between the lines
    //now that the radius has been determined, find tangent points and circle centre
	tangD=r/tan(ang/2),//distance to the tangent point from p2
    circD=r/sin(ang/2),//distance to the circle centre from p2
	//find the angles from the p2 with respect to the postitive x axis
	a12=getAngle(p[0],p[1]),//angle from point 2 to 1
	a23=getAngle(p[2],p[1]),//angle from point 2 to 3
	//find tangent points
	t12=[p[1][0]-cos(a12)*tangD,p[1][1]-sin(a12)*tangD],//tangent point between points 1&2
	t23=[p[1][0]-cos(a23)*tangD,p[1][1]-sin(a23)*tangD],//tangent point between points 2&3
    //find circle centre
	tmid=getMidpoint(t12,t23),//midpoint between the two tangent points
	angCen=getAngle(tmid,p[1]),//angle from point 2 to circle centre
	cen=[p[1][0]-cos(angCen)*circD,p[1][1]-sin(angCen)*circD] //circle center by offseting from point 2 
    )
	[t12,t23,cen];}	
{function parallelFollow(rp,thick=4,minR=1,mode=1)=
    //rp[1][2]==0?[rp[1][0],rp[1][1],0]://return the middle point if the radius is 0
    thick==0?[rp[1][0],rp[1][1],0]://return the middle point if the radius is 0
	let(
    p=getpoints(rp), //get list of points
	r=thick,//get the centre 3 radii
    ang=cosineRuleAngle(p[0],p[1],p[2]),//angle between the lines
    //now that the radius has been determined, find tangent points and circle centre
	tangD=r/tan(ang/2),//distance to the tangent point from p2
	sgn=CWorCCW(rp),//rotation of the three points cw or ccw?let(sgn=mode==0?1:-1)
    circD=mode*sgn*r/sin(ang/2),//distance to the circle centre from p2
	//find the angles from the p2 with respect to the postitive x axis
	a12=getAngle(p[0],p[1]),//angle from point 2 to 1
	a23=getAngle(p[2],p[1]),//angle from point 2 to 3
	//find tangent points
	t12=[p[1][0]-cos(a12)*tangD,p[1][1]-sin(a12)*tangD],//tangent point between points 1&2
	t23=[p[1][0]-cos(a23)*tangD,p[1][1]-sin(a23)*tangD],//tangent point between points 2&3
    //find circle centre
	tmid=getMidpoint(t12,t23),//midpoint between the two tangent points
	angCen=getAngle(tmid,p[1]),//angle from point 2 to circle centre
	cen=[p[1][0]-cos(angCen)*circD,p[1][1]-sin(angCen)*circD],//circle center by offseting from point 2 
	outR=max(minR,rp[1][2]-thick*sgn*mode) //ensures radii are never too small.
    )
	concat(cen,outR);}	
{function findPoint(ang1,refpoint1,ang2,refpoint2,r=0)=
    let(
    m1=tan(ang1),c1=refpoint1.y-m1*refpoint1.x,
	m2=tan(ang2),c2=refpoint2.y-m2*refpoint2.x,
    outputX=(c2-c1)/(m1-m2),
    outputY=m1*outputX+c1
    )
	[outputX,outputY,r];
}
{function RailCustomiser(rp,o1=0,o2,mode=0,minR=0,a1,a2)= 
    /*This function takes a series of radii points and plots points to run along side at a constanit distance, think of it as offset but for line instead of a polygon
    rp=radii points, o1&o2=offset 1&2,minR=min radius, a1&2=angle 1&2
    mode=1 - include endpoints a1&2 are relative to the angle of the last two points and equal 90deg if not defined
    mode=2 - endpoints not included
    mode=3 - include endpoints a1&2 are absolute from the x axis and are 0 if not defined
    negative radiuses only allowed for the first and last radii points
    
    As it stands this function could probably be tidied a lot, but it works, I'll tidy later*/
		let(
        o2undef=o2==undef?1:0,
        o2=o2undef==1?0:o2,
        CWorCCW1=sign(o1)*CWorCCW(rp),
        CWorCCW2=sign(o2)*CWorCCW(rp),
        o1=abs(o1),
        o2b=abs(o2),
		Lrp3=len(rp)-3,
        Lrp=len(rp),
        a1=mode==0&&a1==undef?
                getAngle(rp[0],rp[1])+90:
            mode==2&&a1==undef?
                0:
            mode==0?
                getAngle(rp[0],rp[1])+a1:
                a1,
        a2=mode==0&&a2==undef?
                getAngle(rp[Lrp-1],rp[Lrp-2])+90:
            mode==2&&a2==undef?
                0:
            mode==0?
                getAngle(rp[Lrp-1],rp[Lrp-2])+a2:
                a2,
        OffLn1=[for(i=[0:Lrp3]) o1==0?rp[i+1]:parallelFollow([rp[i],rp[i+1],rp[i+2]],o1,minR,mode=CWorCCW1)],
        OffLn2=[for(i=[0:Lrp3]) o2==0?rp[i+1]:parallelFollow([rp[i],rp[i+1],rp[i+2]],o2b,minR,mode=CWorCCW2)],  
        Rp1=abs(rp[0].z),
        Rp2=abs(rp[Lrp-1].z),
        endP1a=findPoint(getAngle(rp[0],rp[1]),OffLn1[0],a1,rp[0],Rp1),
        endP1b=findPoint(getAngle(rp[Lrp-1],rp[Lrp-2]),OffLn1[len(OffLn1)-1],a2,rp[Lrp-1],Rp2),
        endP2a=findPoint(getAngle(rp[0],rp[1]),OffLn2[0],a1,rp[0],Rp1),
        endP2b=findPoint(getAngle(rp[Lrp-1],rp[Lrp-2]),OffLn2[len(OffLn1)-1],a2,rp[Lrp-1],Rp2),
        absEnda=getAngle(endP1a,endP2a),
        absEndb=getAngle(endP1b,endP2b),
        negRP1a=[cos(absEnda)*rp[0].z*10+endP1a.x,sin(absEnda)*rp[0].z*10+endP1a.y,0.0],
        negRP2a=[cos(absEnda)*-rp[0].z*10+endP2a.x,sin(absEnda)*-rp[0].z*10+endP2a.y,0.0],
        negRP1b=[cos(absEndb)*rp[Lrp-1].z*10+endP1b.x,sin(absEndb)*rp[Lrp-1].z*10+endP1b.y,0.0],
        negRP2b=[cos(absEndb)*-rp[Lrp-1].z*10+endP2b.x,sin(absEndb)*-rp[Lrp-1].z*10+endP2b.y,0.0],
        OffLn1b=(mode==0||mode==2)&&rp[0].z<0&&rp[Lrp-1].z<0?
                concat([negRP1a],[endP1a],OffLn1,[endP1b],[negRP1b])
            :(mode==0||mode==2)&&rp[0].z<0?
                concat([negRP1a],[endP1a],OffLn1,[endP1b])
            :(mode==0||mode==2)&&rp[Lrp-1].z<0?
                concat([endP1a],OffLn1,[endP1b],[negRP1b])
            :mode==0||mode==2?
                concat([endP1a],OffLn1,[endP1b])
            :
                OffLn1
        ,
        OffLn2b=(mode==0||mode==2)&&rp[0].z<0&&rp[Lrp-1].z<0?
                concat([negRP2a],[endP2a],OffLn2,[endP2b],[negRP2b])
            :(mode==0||mode==2)&&rp[0].z<0?
                concat([negRP2a],[endP2a],OffLn2,[endP2b])
            :(mode==0||mode==2)&&rp[Lrp-1].z<0?
                concat([endP2a],OffLn2,[endP2b],[negRP2b])
            :mode==0||mode==2?
                concat([endP2a],OffLn2,[endP2b])
            :
                OffLn2
        )//end of let()
		o2undef==1?OffLn1b:concat(OffLn2b,revList(OffLn1b));}
{function revList(list)=//reverse list
    let(Llist=len(list)-1)
    [for(i=[0:Llist]) list[Llist-i]];
}   
{function CWorCCW(p)=
	let(
    Lp=len(p),
	e=[for(i=[0:Lp-1]) (p[wrap(i+0,Lp)].x-p[wrap(i+1,Lp)].x)*(p[wrap(i+0,Lp)].y+p[wrap(i+1,Lp)].y)]
    )  
    sign(sum(e));}
{function CentreN2PointsArc(p1,p2,cen,mode=0,fn)=
    /* This function plots an arc from p1 to p2 with fn increments using the cen as the centre of the arc.
    the mode determines how the arc is plotted
    mode==0, shortest arc possible 
    mode==1, longest arc possible
    mode==2, plotted clockwise
    mode==3, plotted counter clockwise
    */
	let(
    CWorCCW=CWorCCW([cen,p1,p2]),//determine the direction of rotation
    //determine the arc angle depending on the mode
    p1p2Angle=cosineRuleAngle(p2,cen,p1),
    arcAngle=
        mode==0?p1p2Angle:
        mode==1?p1p2Angle-360:
        mode==2&&CWorCCW==-1?p1p2Angle:
        mode==2&&CWorCCW== 1?p1p2Angle-360:
        mode==3&&CWorCCW== 1?p1p2Angle:
        mode==3&&CWorCCW==-1?p1p2Angle-360:
        cosineRuleAngle(p2,cen,p1)
    ,
    r=pointDist(p1,cen),//determine the radius
	p1Angle=getAngle(cen,p1) //angle of line 1
    )
    [for(i=[0:fn]) [cos(p1Angle+(arcAngle/fn)*i*CWorCCW)*r+cen[0],sin(p1Angle+(arcAngle/fn)*i*CWorCCW)*r+cen[1]]];}
{function moveRadiiPoints(rp,tran=[0,0],rot=0)=
	[for(i=rp) 
		let(
        a=getAngle([0,0],[i.x,i.y]),//get the angle of the this point
		h=pointDist([0,0],[i.x,i.y]) //get the hypotenuse/radius
        )
		[h*cos(a+rot)+tran.x,h*sin(a+rot)+tran.y,i.z]//calculate the point's new position
	];}
{function invtan(run,rise)=
    let(a=abs(atan(rise/run)))
    rise==0&&run>0?0:rise>0&&run>0?a:rise>0&&run==0?90:rise>0&&run<0?180-a:rise==0&&run<0?180:rise<0&&run<0?a+180:rise<0&&run==0?270:rise<0&&run>0?360-a:"error";}
{function cosineRuleAngle(p1,p2,p3)=
    let(
    p12=abs(pointDist(p1,p2)),
    p13=abs(pointDist(p1,p3)),
    p23=abs(pointDist(p2,p3))
    )
    acos((sq(p23)+sq(p12)-sq(p13))/(2*p23*p12));}	
{function sum(list, idx = 0, result = 0) = 
	idx >= len(list) ? result : sum(list, idx + 1, result + list[idx]);}
function sq(x)=x*x;
function getGradient(p1,p2)=(p2.y-p1.y)/(p2.x-p1.x);
function getAngle(p1,p2)=invtan(p2[0]-p1[0],p2[1]-p1[1]);
function getMidpoint(p1,p2)=[(p1[0]+p2[0])/2,(p1[1]+p2[1])/2]; //returns the midpoint of two points
function pointDist(p1,p2)=sqrt(abs(sq(p1[0]-p2[0])+sq(p1[1]-p2[1]))); //returns the distance between two points
function isColinear(p1,p2,p3)=getGradient(p1,p2)==getGradient(p2,p3)?1:0;//return 1 if 3 points are colinear
 module polyline(p) {for(i=[0:max(0,len(p)-1)])line(p[i],p[wrap(i+1,len(p) )]);
} // polyline plotter
module line(p1, p2 ,width=0.3) { // single line plotter
    hull() {
        translate(p1) circle(width);
        translate(p2) circle(width);
    }
}
function getpoints(p)=[for(i=[0:len(p)-1])[p[i].x,p[i].y]];// gets [x,y]list of[x,y,r]list
function wrap(x,x_max=1,x_min=0) = (((x - x_min) % (x_max - x_min)) + (x_max - x_min)) % (x_max - x_min) + x_min; // wraps numbers inside boundaries
{function rnd(a = 1, b = 0, s = []) = 
  s == [] ? 
   (rands(min(a, b), max(   a, b), 1)[0]) 
  : 
   (rands(min(a, b), max(a, b), 1, s)[0])
;} // nice rands wrapper 
