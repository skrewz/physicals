// Use partname to control which object is being rendered:
//
// _partname_values catcher
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 0.2;

wall_w = 1;

hold_length = 10;
hold_height = 3.5;
hold_clear_w1_w2 = [13.5+0.2,12.7+0.2];
shield_w = 16;
shield_l = 25;
shield_h = 8;

magnet_r = 2.5;
magnet_clear_r = 2.8;
magnet_height_diff = 0.4;

module catcher()
{
  w1_w2_diff = hold_clear_w1_w2[0]-hold_clear_w1_w2[1];

  module hold_helper (height,extra_width)
  {
    linear_extrude(height=height)
    {
      polygon([
        [-w1_w2_diff/2-extra_width/2, 0],
        [hold_clear_w1_w2[0]-w1_w2_diff/2+extra_width/2, 0],
        [hold_clear_w1_w2[1]+extra_width/2, hold_length],
        [-extra_width/2, hold_length],
      ]);
    }
  }
  build_height = max(hold_height+wall_w,shield_h+wall_w);
  difference()
  {
    hold_helper(build_height,2*wall_w);
    hold_helper(hold_height,0);
    translate([
      hold_clear_w1_w2[0]/2-w1_w2_diff/2/2,
      hold_length/2,
      hold_height+magnet_height_diff
    ]) {
      cylinder(r=magnet_clear_r,h=build_height);
    }
  }

  translate([0,hold_length,0])
  {
    difference()
    {
      // main cage (the shield):
      translate([-wall_w,0,0])
        cube([shield_w+2*wall_w,shield_l+wall_w+wall_w,shield_h+wall_w]);
      // main extraction from the shield:
      translate([0,wall_w,0])
        cube([shield_w,shield_l,shield_h]);
      // through from hold to shield:
      translate([0,0,0])
        cube([hold_clear_w1_w2[1],2*wall_w,hold_height]);
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
  catcher();
} else if ("catcher" == partname)
{
    catcher();
}
