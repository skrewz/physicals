// Use partname to control which object is being rendered:
//
// _partname_values riser
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

rise_amount = 50;

plate_diameter = 140;
plate_height = 10;
foot_diameter = 10;
foot_height = rise_amount-plate_height;

module riser()
{
  // Centre foot, ever so slightly shorter for stability:
  translate([0,0,0.02*foot_height])
    cylinder(r=foot_diameter/2,h=0.98*foot_height,$fs=foot_diameter/20);
  // Outer feet:
  for(ang = [0,120,240]) {
    rotate([0,0,ang])
      translate([plate_diameter/2-foot_diameter/2,0,0])
        cylinder(r=foot_diameter/2,h=foot_height,$fs=foot_diameter/20);
  }
  translate([0,0,foot_height])
  {
    /* hull() */
    /* { */
    /*   for(ang = [0,120,240]) { */
    /*     rotate([0,0,ang]) */
    /*       translate([plate_diameter/2-foot_diameter/2,0,0]) */
    /*         cylinder(r=foot_diameter/2,h=plate_height,$fs=foot_diameter/20); */
    /*   } */
    /* } */
    for(ang = [0,120,240]) {
      hull()
      {
        rotate([0,0,ang])
          translate([plate_diameter/2-foot_diameter/2,0,0])
            cylinder(r=foot_diameter/2,h=plate_height,$fs=foot_diameter/20);
        rotate([0,0,(ang+120)%360])
          translate([plate_diameter/2-foot_diameter/2,0,0])
            cylinder(r=foot_diameter/2,h=plate_height,$fs=foot_diameter/20);
      }
      hull()
      {
        cylinder(r=foot_diameter/2,h=plate_height,$fs=foot_diameter/20);
        rotate([0,0,ang])
          translate([plate_diameter/2-foot_diameter/2,0,0])
            cylinder(r=foot_diameter/2,h=plate_height,$fs=foot_diameter/20);
      }
    }
  }
}


// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.
if ("display" == partname)
{
  riser();
} else if ("riser" == partname)
{
  rotate([180,0,0])
  {
    riser();
  }
}
