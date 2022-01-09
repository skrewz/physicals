// Use partname to control which object is being rendered:
//
// _partname_values clasp holder lid
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 5;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 2;

max_roll_r = 35;
roll_h = 105;
wall_w = 3;

// how much the lid() wraps down over the holder():
lid_overhang = 10;
lid_oversize_mm = 0.4;

clasp_window_width = 10;
clasp_oversize_mm = 1;


module holder()
{
  // The cylinder itself:
  difference()
  {
    cylinder(r=max_roll_r+wall_w,h=wall_w+roll_h+lid_overhang);
    translate([0,0,wall_w])
      cylinder(r=max_roll_r,h=wall_w+roll_h+lid_overhang);
    // The cutout for paper exit:
    translate([max_roll_r,0,wall_w])
      rotate([0,0,70])
        cube([10*wall_w,wall_w,wall_w+roll_h+lid_overhang]);
  }
}
module lid()
{
  lid_actual_outer_r = max(
    max_roll_r+wall_w+lid_oversize_mm+wall_w,
    max_roll_r+wall_w+clasp_oversize_mm+wall_w
  );
  difference()
  {
    cylinder(r=lid_actual_outer_r,h=wall_w+wall_w+lid_overhang);
    translate([0,0,-0.01])
      cylinder(r=max_roll_r+wall_w+lid_oversize_mm,h=lid_overhang+0.01);
  }
}
module clasp()
{
  difference()
  {
    cylinder(r=max_roll_r+wall_w+clasp_oversize_mm+wall_w,h=wall_w+roll_h);
    translate([0,0,wall_w])
      cylinder(r=max_roll_r+wall_w+clasp_oversize_mm,h=3*wall_w+roll_h);
    // A window to get to the paper:
    translate([0,-clasp_window_width/2,wall_w])
      cube([5*wall_w+max_roll_r,clasp_window_width,2*wall_w+roll_h]);
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
%
  clasp();
  translate([0,0,wall_w])
    holder();
  translate([0,0,roll_h+wall_w])
  {
  %
    lid();
  }
} else if ("clasp" == partname)
{
  clasp();
} else if ("lid" == partname)
{
  rotate([180,0,0])
  lid();
} else if ("holder" == partname)
{
  holder();
}
