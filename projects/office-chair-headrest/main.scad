// Use partname to control which object is being rendered:
//
// _partname_values headrest
partname = "headrest";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 6 : 1;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

lower_arc_lean_angle = 8;
lower_arc_height = 20;

bolt_head_clearing_rh = [3,3];

wall_w = 4;
lower_arc_wall_w = 8;
stretch_arc_wall_w = 16;

lower_arc_ir = 500;

upper_arc_height = 20;
upper_arc_ir = 90;
upper_arc_lean_angle = -20;

mount_hole_r = 1.7;
mount_hole_height = 6;
mount_hole_angles = [-10.7,0,10.7];

upper_arc_displacement = [-90,0,220];


arm_width = 50;
arm_vertical_resolution = $preview ? 15 : 4;

// This produces the xyz and rotation coordinates for a given height of the arm:
function arm_xyza_for_height (h, linear_offset) =
  [
    ((upper_arc_displacement[0]-linear_offset*upper_arc_displacement[2])/upper_arc_displacement[2]^2)*h^2+linear_offset*h,
    0,
    h,
    h/(upper_arc_displacement[2]-0)*-(90+upper_arc_lean_angle)
  ];

module arm(linear_offset=0.7,arm_height=upper_arc_displacement[2],w_w=2*lower_arc_wall_w)
{
  module segment_at(h)
  {
    coord = arm_xyza_for_height (h, linear_offset);
    translate([coord[0],coord[1],coord[2]])
    {
      rotate([0,coord[3],0])
      {
        translate([0,-arm_width/2,0])
        {
          cube([w_w, arm_width, 0.01]);
        }
      }
    }
  }
  // The extension of the arm:
  for(h=[0:arm_vertical_resolution:arm_height-arm_vertical_resolution])
  {
    hull()
    {
      segment_at(h);
      segment_at(h+arm_vertical_resolution);
    }
  }
  // A last connecting segment, to ensure we grab on:
  hull()
  {
    segment_at(arm_height);
    segment_at(floor(arm_height/arm_vertical_resolution)*arm_vertical_resolution);
  }
}

module arc_of_circle(ir, or, height, angle_in_either_direction, lean_angle)
{

  rotate([0,0,-angle_in_either_direction])
  {
    rotate_extrude(angle=2*angle_in_either_direction)
    {
      translate([ir,0,0])
      {
        polygon([
          [0, 0],
          [or-ir, 0],
          // (upside down) law of sines in play here:
          [or-ir-(height/sin(90-lean_angle)*sin(lean_angle)), height],
          [0-(height/sin(90-lean_angle)*sin(lean_angle)), height],
        ]);
      }
    }
  }
}

module headrest()
{
  difference()
  {
    union()
    {
      // Adding a support brace
      translate([0,-arm_width/2,lower_arc_height])
      {
        hull()
        {
          for (coord = [
              [lower_arc_wall_w/2,0,-lower_arc_height+1.0],
              [0,0,0],
              [2*lower_arc_wall_w,0,0],
              [4*lower_arc_wall_w,0,40],
              ]) {
            translate(coord)
            {
              rotate([-90,0,0])
              {
                cylinder(r=0.1,h=arm_width);
              }
            }
          }
        }
      }
      lower_arc();
      arm();

      translate(upper_arc_displacement)
      {
        upper_arc();
      }
    }
    translate([-lower_arc_ir,0,mount_hole_height])
    {
      for (zrot = mount_hole_angles)
      {
        rotate([0,90,zrot])
        {
          cylinder(r=mount_hole_r, h=2*lower_arc_ir);
          translate([0,0,lower_arc_ir+lower_arc_wall_w-bolt_head_clearing_rh[1]])
          {
            cylinder(r=bolt_head_clearing_rh[0], h=lower_arc_ir);
          }
        }
      }
    }
  }
}

module stretch_arc(h, lean_angle=lower_arc_lean_angle, w_w=wall_w)
{
  translate([-lower_arc_ir,0,0])
  {
    arc_of_circle(lower_arc_ir,lower_arc_ir+w_w,h,3,lean_angle);
  }
}

module lower_arc()
{
  translate([-lower_arc_ir,0,0])
  {
    arc_of_circle(lower_arc_ir,lower_arc_ir+lower_arc_wall_w,lower_arc_height,12,lower_arc_lean_angle);
  }
}

module upper_arc()
{
  translate([-upper_arc_ir,0,0])
  {
    arc_of_circle(upper_arc_ir,upper_arc_ir+wall_w,20,50,upper_arc_lean_angle);
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
  headrest();
} else if ("test" == partname)
{
  arm();
} else if ("headrest" == partname)
{
  headrest();
}
