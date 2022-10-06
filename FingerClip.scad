
//Diamter of the spring coil
spring_diameter = 7.5;
//Diameter of hole for spring wire, significantly oversized
spring_wire_diameter = 2.5;
//Angle between horizontal and a line from the centre of
//the spring to the to the wire hole
lower_spring_angle = -8;
upper_spring_angle = -20;
//Distance from the centre of the spring to the centre of the wire hole
spring_dist = 18;
//Width of the spring (measure space between two arms (undersize this)
spring_width = 10;
spring_extra_space = 2;
spring_cutout_len = spring_dist+spring_extra_space;

//Seperation of plates when the they are parallel
plate_sep = 3;

//Length that covers the finger
finger_len = 29;
//Diameter of the cutout
finger_diam = 18;
//Finger cut out widened by:
finger_extra_width = 6;
//Cut-out offet
finger_offset_z = 2.5;

len_2_pivot = finger_len+spring_dist+3;

length = len_2_pivot+20;
width = 25;
height = 10;

//Sets the angle of pinch mechanism
max_open_angle = 12;

//Parameters for walls to keep clip inline
wall_width = 3.5;
gap_to_wall = 1;

//Used to ensure areas overlap for boolean operations
fuzz = .1;

clip();
translate([width+6,0,-height+6])
{
    clip_with_walls(6);
    
}
module clip_with_walls(height=height)
{
    difference()
    {
        union()
        {
            clip(width+2,height,spring_angle=lower_spring_angle,rounded=false);
            translate([width/2+gap_to_wall,spring_cutout_len,-plate_sep/2-height])
                cube([wall_width,len_2_pivot-spring_cutout_len,2*height+plate_sep]);
            
            translate([-width/2-gap_to_wall-wall_width,spring_cutout_len,-plate_sep/2-height])
                cube([wall_width,len_2_pivot-spring_cutout_len,2*height+plate_sep]);
            translate([0,len_2_pivot-13.5-35-3.5,-plate_sep/2-height+1])
                cube([34,45,2],center=true);
            translate([0,len_2_pivot-finger_len+height,-plate_sep/2])
                rotate([0,90,0])rotate([0,0,-90])
                hull()quater_pipe(height,width,true); // this is a bit stupid, but works
        }
        translate([0,len_2_pivot-finger_diam/2-6,-plate_sep/2-height-fuzz])
            hull()
            {
                cylinder(d=7.5,h=1);
                translate([-8.5,-10,3])cube([17,30,1]);
            }

        translate([-25/2,-4,-plate_sep/2-height-fuzz])
            cube([25,finger_len,1.4]);
        
        sx = 17-1.6;
        sy = 73.5/2-1.6;
        translate([0,len_2_pivot-73.5/2,-height])
        {
            translate([sx,sy,0])cylinder(d=2,h=999,center=true);
            translate([-sx,sy,0])cylinder(d=2,h=999,center=true);
            translate([sx,-sy,0])cylinder(d=2,h=999,center=true);
            translate([-sx,-sy,0])cylinder(d=2,h=999,center=true);
            translate([sx,sy,0])cylinder(d=8,h=999);
            translate([-sx,sy,0])cylinder(d=8,h=999);
        }
        
    }
    
    
}

module clip(width=width,height=height,spring_angle=upper_spring_angle,rounded=true)
{
    difference(){
        translate([0,0,-plate_sep/2]){
            difference(){
                //Main block
                translate([0,-length/2+len_2_pivot,-height/2])
                    if (rounded)
                    {
                        r_cube([width,length,height],r=2,center=true);
                    }
                    else
                    {
                        cube([width,length,height],center=true);
                    }
                
                
                //Hole for spring wire
                rotate([spring_angle,0,0])
                translate([0,spring_dist,0])
                rotate([0,90,0])
                cylinder(d=spring_wire_diameter,h=999,center=true,$fn=10);
                
                //Cutout to thin area for spring
                translate([width/2+spring_width/2,spring_dist/2+1,-height/2])
                cube([width,spring_cutout_len,2*height],center=true);
                //Cutout to thin area for spring
                translate([-(width/2+spring_width/2),spring_dist/2+1,-height/2])
                cube([width,spring_cutout_len,2*height],center=true);
            }
        }
        
        //Widened and splayed cut-out for finger
        translate([0,len_2_pivot-finger_len,finger_offset_z])
        rotate([-90,0,0])
        splayed_stretched_cyl(d=finger_diam,h=finger_len+fuzz,ds=finger_diam+3,hs=10,stretch=finger_extra_width,sp_bottom=false);

        
        //Hole for the coil of the spring
        rotate([0,90,0])
        cylinder(d=spring_diameter,h=999,center=true);
        
        //Cutout to slope the back of the clip
        rotate([max_open_angle,0,0])
        translate([0,-length/2,height/2])
        cube([width+fuzz,length,height],center=true);
    }
}

module splayed_stretched_cyl(d,h,ds,hs,stretch,sp_bottom=true,center=false)
{
    ang = sp_bottom ? 0 : 180;
    flip_translation = sp_bottom ? 0 : h;
    center_translation = center ? -h/2 : 0;
    translate([0,0,center_translation])
    translate([0,0,flip_translation])
    rotate([0,ang,0])
    {
        delta_d = ds-d;
        hull()
        {
            translate([-stretch/2,0,0])
            cylinder(d=d,h=h,$fn=30);
            translate([stretch/2,0,0])
            cylinder(d=d,h=h,$fn=30);
        }
        hull()
        {
            translate([-stretch/2,0,0])
            cylinder(d1=ds,d2=d,h=hs/3,$fn=30);
            translate([stretch/2,0,0])
            cylinder(d1=ds,d2=d,h=hs/3,$fn=30);
        }
        hull()
        {
            translate([-stretch/2,0,0])
            cylinder(d1=d+2*delta_d/3,d2=d,h=2*hs/3,$fn=30);
            translate([stretch/2,0,0])
            cylinder(d1=d+2*delta_d/3,d2=d,h=2*hs/3,$fn=30);
        }
        hull()
        {
            translate([-stretch/2,0,0])
            cylinder(d1=d+delta_d/3,d2=d,h=hs,$fn=30);
            translate([stretch/2,0,0])
            cylinder(d1=d+delta_d/3,d2=d,h=hs,$fn=30);
        }
    }
}

module r_cube(size,r,center=false,fn=20)
{
    c_trans = center ? [0,0,0] : size/2;
    translate(c_trans)
        minkowski()
        {
          cube([size[0]-2*r, size[1]-2*r, size[2]-2*r],center=true);
          sphere(r=r,$fn=fn);
        }
        
}

module quater_pipe(r,h,center=false){
    ct = center? [0,0,-h/2] : [0,0,0];
    translate(ct)
    {
        difference()
        {
            cube([r,r,h]);
            translate([0,0,-fuzz])
                cylinder(r=r,h=999,$fn=15);
        }
    }
}