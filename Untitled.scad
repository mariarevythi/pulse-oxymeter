width = 34;;
length = 73.5;
height = 22.5;
wall_thick=1;
board_len=64;
board_width=28;
board_pos=[length-board_len-2.5-3.5,(width-board_width)/2,0];
fuzz=.1;
difference()
{
    union()
    {
        //main block
        cube([length,width,height]);
        //power port blck
        translate([length-58-18/2,fuzz,0])
            rotate([90,0,0])
            cube([18,height-4,1]);
    }
    //main hole
    translate([wall_thick, wall_thick, wall_thick])
        cube([length-2*wall_thick,width-2*wall_thick,height]);
    //power block cutout
    translate([length-58-16/2,5,wall_thick])
            rotate([90,0,0])
            cube([16,height-6,5]);
    //screen cutout
    translate([length-34-25,11,-10])
        cube([25,9,999]);
    //power connector hole
    translate([length-58,-2,8.8])
        rotate([-90,0,0])
        cylinder(d=10,h=10,center=true);
}

difference()
{
union()
{
translate([1.6,1.6,0])
    lid_standoff();
translate([length-1.6,1.6,0])
    lid_standoff();
translate([1.6,width-1.6,0])
    lid_standoff();
translate([length-1.6,width-1.6,0])
    lid_standoff();
}
translate(board_pos+[-.5,-.5,1])
cube([board_len+1,board_width+1,999]);
}
translate(board_pos)
{
    translate([1.6,1.6,0])
        board_standoff();
    translate([board_len-1.6,1.6,0])
        board_standoff();
    translate([1.6,board_width-1.6,0])
        board_standoff();
    translate([board_len-1.6,board_width-1.6,0])
        board_standoff();
}

//
module board_standoff()
{
    difference()
    {
        translate([0,0,15.5/2])
            cube([5,5,15.5],center=true);
        translate([0,0,1])
            cylinder(d=2,h=999);
    }
}

module lid_standoff()
{
    difference()
    {
        translate([0,0,height/2])
            cube([3.2,3.2,height],center=true);
        translate([0,0,1])
            cylinder(d=2,h=999);
    }
}


