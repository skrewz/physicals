// Use partname to control which object is being rendered:
//
// _partname_values protector
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 1 : 0.5;

foot_inner_r = 6.7; // d=13.5 measured
foot_inner_support_height = 5; // arbitrary; can sink in
foot_outer_r = 8.3; // d=16.2 measured
foot_outer_support_height = 2.7;
foot_angle = 15;

// The angle that the base of the support interacts with the floor with:
support_angle = 0;


module protector()
{

  module offset_cylinder(r,h,offset)
  {
    hull()
    {
      cylinder(r=r,h=0.01);
      translate([offset,0,h])
      {
        cylinder(r=r,h=0.01);
      }
    }
  }

  difference()
  {
    union()
    {
      offset_cylinder(foot_inner_r,foot_inner_support_height,sin(foot_angle)*foot_inner_support_height);
      intersection()
      {
        offset_cylinder(foot_outer_r,foot_inner_support_height,sin(foot_angle)*foot_inner_support_height);
        translate([0,0,foot_outer_support_height])
        {
          rotate([0,foot_angle,0])
          {
            mirror([0,0,1])
            {
              cylinder(r=foot_outer_r,foot_outer_support_height+sin(foot_angle)*foot_outer_r);
            }
          }
        }
      }
    }
    translate([foot_outer_r,0,0])
    {
      rotate([0,support_angle,0])
      {
        translate([-foot_outer_r,0,0])
        {
          mirror([0,0,1])
          {
            cylinder(r=foot_outer_r,foot_outer_support_height+sin(foot_angle)*foot_outer_r);
          }
        }
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
  protector();
} else if ("protector" == partname)
{
  rotate([0,-support_angle,0])
  {
    protector();
  }
}
