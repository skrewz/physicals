// Use partname to control which object is being rendered:
//
// _partname_values spiral
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


// Assuming this'll be put into a sinkhole cover with a circular nature, set
// outer_r to the maximum radius of the area on which the device can rest and
// set inner_r to the maximum radius of the tube of the drain below it:
//
outer_r = 85/2;
inner_r = 65/2;

// This controls how long the spiral will be, how many veins the spiral will
// have and how many twists (1==a complete rotation) it'll undergo:
funnel_depth = 70;
num_veins = 3;
twists = 0.4;


wall_w = 2;

module spiral()
{
  spiral_depth = 0.7*funnel_depth;
  combiner_depth = 0.3*funnel_depth;

  // The mounting ring:
  difference()
  {
    union()
    {
      cylinder(r=outer_r, h=wall_w);
      // This adds a bit of a drip ring:
      cylinder(r=inner_r, h=2*wall_w);
    }
    // make this slightly smaller to allow the spiral to grab on:
    translate([0,0,-0.01])
    {
      cylinder(r=inner_r-wall_w,h=2*wall_w+0.02);
    }
  }

  // The spirals:
  for (rot = [0:360/num_veins:360])
  {
    rotate([0,0,rot])
    {
      /*
      translate([0,-10/2,0])
      {
        cube([inner_r,10,wall_w]);
      }
      */
      linear_extrude(twist=twists*360, height=spiral_depth, convexity=10)
      {
        translate([inner_r-20,0])
        {
          scale([2,0.7,0])
          {
            circle(r=10);
          }
        }
      }
    }
  }

  // This aims to lead runoff into one particular wall:
  for (rot = [0:360/num_veins:360])
  {
    hull()
    {
      translate([inner_r-2,0,funnel_depth])
      {
        cylinder(r=2,h=0.01);
      }
      rotate([0,0,rot])
      {
        rotate([0,0,-twists*360])
        {
          translate([0,0,spiral_depth])
          {
            translate([inner_r-20,0])
            {
              scale([2,0.7,0])
              {
                cylinder(r=10,h=0.01);
              }
            }
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
  spiral();
} else if ("spiral" == partname)
{
  spiral();
}
