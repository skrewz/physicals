// Use partname to control which object is being rendered:
//
// _partname_values ball_container
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 6 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

wall_w = 1.7;

support_overlap = 2*wall_w;

num_supports = 5;
support_extra_height = 20;

ball_container_top_radius = 65;
squash_parameters = [1,1,0.6];

assert(1 == squash_parameters[0]);
assert(1 == squash_parameters[1]);

module bowl_pos()
{
  translate([0,0,ball_container_top_radius*squash_parameters[2]])
  {
    difference()
    {
      union()
      {
        scale(squash_parameters)
        {
          sphere(r=ball_container_top_radius);
        }
      }
      cylinder(r=ball_container_top_radius,h=ball_container_top_radius);
      translate([0,0,-ball_container_top_radius*squash_parameters[2]-wall_w])
      {
        cylinder(r=ball_container_top_radius,h=0.2*squash_parameters[2]*ball_container_top_radius);
      }
    }
  }
}
module bowl_neg()
{
  translate([0,0,ball_container_top_radius*squash_parameters[2]])
  {
    difference()
    {
      scale(squash_parameters)
      {
        sphere(r=ball_container_top_radius-wall_w);
      }
      cylinder(r=ball_container_top_radius,h=ball_container_top_radius);
      translate([0,0,-ball_container_top_radius*squash_parameters[2]])
      {
        cylinder(r=ball_container_top_radius,h=0.2*squash_parameters[2]*ball_container_top_radius);
      }
    }
  }
}
module bowl()
{
  difference()
  {
    bowl_pos();
    translate([0,0,0.01])
    {
      bowl_neg();
    }
  }
}

module ball_container()
{
  difference()
  {
    union()
    {
      bowl_pos();
      for (rot = [0:360/num_supports:360])
      {
        rotate([0,0,rot])
        {
          hull()
          {
            translate([ball_container_top_radius*squash_parameters[0],0,-support_extra_height])
            {
              cylinder(r=0.7*wall_w,h=0.1);
              translate([-2*wall_w,0,0])
              {
                cylinder(r=0.7*wall_w,h=0.1);
              }
            }
            translate([0.5*ball_container_top_radius*squash_parameters[0],0,ball_container_top_radius*squash_parameters[2]-0.01])
            {
              cylinder(r=0.7*wall_w,h=0.1);
            }
            translate([ball_container_top_radius*squash_parameters[0]-wall_w,0,ball_container_top_radius*squash_parameters[2]-0.01])
            {
              cylinder(r=0.7*wall_w,h=0.1);
            }
          }
        }
      }
    }
    translate([0,0,0.1])
    {
      bowl_neg();
    }
    // Cut out a bowl's notches from below:
    translate([0,0,-support_extra_height-0.01])
    {
      difference()
      {
        cylinder(r=ball_container_top_radius,h=wall_w);
        translate([0,0,-0.01])
        {
          cylinder(r=ball_container_top_radius-2*wall_w,h=10);
        }
      }
    }
  }
}

/*
      for (rot = [0:360/num_supports:360])
      {
        rotate([0,0,rot])
        {
          translate([-wall_w/2,0,-ball_container_top_radius*squash_parameters[2]-support_extra_height])
          {
            difference()
            {
              cube([
                wall_w,
                ball_container_top_radius*squash_parameters[0],
                ball_container_top_radius*squash_parameters[2]+support_extra_height,
              ]);
              translate([0,ball_container_top_radius*squash_parameters[0]-support_overlap,0])
              {
                translate([-wall_w,0,-0.01])
                {
                  cube([
                    3*wall_w,
                    support_overlap+0.01,
                    wall_w
                  ]);
                }
              }
            }
          }
        }
      }
      */

// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.
if ("display" == partname)
{
  ball_container();
} else if ("ball_container" == partname)
{
  rotate([180,0,0])
  {
    ball_container();
  }
}
