// Use partname to control which object is being rendered:
//
// _partname_values funnel
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
inner_r_upper = 0.75*inner_r;

// This controls how long the funnel will be
funnel_max_depth = 120;


wall_w = 2;

module funnel()
{
  combiner_depth = funnel_max_depth - inner_r_upper;
  cup_y_squish = 0.5;

  module cup (or)
  {
    intersection()
    {
      difference()
      {
        scale([1,cup_y_squish,1])
        {
          sphere(r=2*or);
        }
        scale([1,cup_y_squish-wall_w/(2*or)/2,1])
        {
          sphere(r=2*or-wall_w);
        }
      }
      translate([-2*inner_r_upper,-inner_r_upper,0])
      {
        cube([2*inner_r_upper,2*inner_r_upper,2*inner_r_upper]);
      }
    }
  }

  module combiner (lower_r, upper_r, height)
  {
    hull()
    {
      cylinder(r1=lower_r, r2=upper_r, h=0.01);
      translate([upper_r,0,height])
      {
        intersection()
        {
          translate([-2*upper_r,-upper_r,0])
          {
            cube([2*upper_r,2*upper_r,0.1]);
          }
          cup(upper_r);
        }
      }
    }
  }
  // The mounting ring:
  difference()
  {
    union()
    {

      translate([0,0,0.5*wall_w])
      {
        minkowski()
        {
          difference()
          {
            cylinder(r=outer_r-0.5*wall_w, h=0.01);
            cylinder(r=inner_r-0.5*wall_w, h=0.01);
          }
          sphere(r=0.5*wall_w,$fs=wall_w/4);
        }
      }
      translate([0,0,0.5*wall_w])
      {
        combiner(inner_r, inner_r_upper, combiner_depth);
        translate([inner_r_upper,0,combiner_depth])
        {
          cup(inner_r_upper);
        }
      }
    }
    translate([0,0,0.5*wall_w-0.01])
    {
      combiner(inner_r-wall_w, inner_r_upper-wall_w, combiner_depth+0.02);
      //cylinder(r1=inner_r-wall_w, r2=inner_r_upper-wall_w, h=combiner_depth+0.02);
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
  funnel();
} else if ("funnel" == partname)
{
  funnel();
}
