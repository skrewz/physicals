// Use partname to control which object is being rendered:
//
// _partname_values distance_piece
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

keyboard_depth = 164;
wrist_support_depth = 50;
table_cutout_thickness = 20+1;
table_clasp_depth = 40;
keyboard_clasp_depth = 10;
keyboard_clasp_height = 14;

keyboard_foot_depth = 69;
keyboard_foot_radius = 10;

wall_w = 1;

support_width = 50;

module distance_piece()
{
  difference()
  {
    cube([support_width,wrist_support_depth+keyboard_depth,wall_w]);
    translate([support_width/2,wrist_support_depth+keyboard_foot_depth,-0.01])
    {
      cylinder(r=keyboard_foot_radius,h=wall_w+0.02);
    }
  }
  translate([0,-wall_w,-table_cutout_thickness+wall_w])
  {
    cube([support_width,wall_w,table_cutout_thickness]);
    translate([0,wall_w,0])
    {
      cube([support_width,table_clasp_depth,wall_w]);
    }
  }
  translate([0,keyboard_depth+wrist_support_depth,0])
  {
    cube([support_width,wall_w,keyboard_clasp_height]);
    translate([0,-keyboard_clasp_depth,keyboard_clasp_height])
    {
      cube([support_width,keyboard_clasp_depth+wall_w,wall_w]);
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
  distance_piece();
} else if ("distance_piece" == partname)
{
  rotate([0,90,0])
  {
    distance_piece();
  }
}
