// Use partname to control which object is being rendered:
//
// _partname_values holder
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 2;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

// Primary provided varables:
// The bowl insert that we're making this bowl holder for. Radius and
// depth/length of cylinder cutout:
insert_rd = [(97+2)/2,18.5+1];

// Secondary provided varables:

// The extra radius around insert_rd[0] that should also be supported:
rim_width = 7;
// Generic wall width in many places:
wall_w = 2;

// the depth of the groove for fingers to grab under the insert_rd insert:
finger_cutout_d = 4;

// Derived variables:
outer_upper_r = insert_rd[0] + rim_width;
holder_h = insert_rd[1] + wall_w;

module holder()
{
  radius_to_outer_rim = sqrt(pow(outer_upper_r,2) + pow(holder_h,2));
  difference()
  {
    intersection()
    {
      sphere(r=radius_to_outer_rim);
      translate([-radius_to_outer_rim,-radius_to_outer_rim,0])
      {
        cube([2*radius_to_outer_rim,2*radius_to_outer_rim,holder_h]);
      }
    }
    translate([0,0,wall_w])
    {
      cylinder(r=insert_rd[0], h=insert_rd[1]+0.01);
    }

    translate([0,0,holder_h])
    {
      rotate([90,0,0])
      {
        translate([0,0,-2*(insert_rd[0]+rim_width)])
        {
          scale([2,1,1])
          {
            cylinder(r=finger_cutout_d, h=4*(insert_rd[0]+rim_width+0.01));
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
  holder();
} else if ("holder" == partname)
{
  holder();
}
