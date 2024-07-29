// Use partname to control which object is being rendered:
//
// _partname_values probemount
partname = "display";

include <libs/compass.scad>
include <libs/metric_bolts_and_nuts.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 1 : 0.5;


probemount_r = 10;
probemount_outer_h = 47;


cable_exit_height = 4;

max_expected_flatpiece_rotation_travel = 5;
tool_path_clearance_r = (6+6)/2;

wall_w = 2;
m6_cutout_r = 3.05;
m6_nut_fn6_r = 6;
m3_nut_height_cutout = 3;

spring_free_rotation_clearing_r = 4.5;


rotation_pin_cutout_r = 0.8;
rotation_pin_height = probemount_outer_h-1.5*rotation_pin_cutout_r;
rotation_pin_horiz_offset = 0.6*probemount_r;
flatpiece_wdh = [5,1,15];
flatpiece_rot_minmax = [-90,-90-max_expected_flatpiece_rotation_travel];

springmount_radius = 7;
springmount_extension = 17;
springmount_height = rotation_pin_height-10;

probe_flathead_height = 29;

module probemount()
{
  difference()
  {
    difference()
    {
      hull()
      {
        cylinder(r=probemount_r, h=probemount_outer_h);
        translate([springmount_extension,0,0])
        {
          cylinder(r=springmount_radius, h=probemount_outer_h);
        }
      }
      translate([0,0,wall_w])
      {
        cylinder(r=probemount_r-wall_w, h=probemount_outer_h-flatpiece_wdh[2]);
      }
      translate([0,0,wall_w])
      {
        cylinder(r=tool_path_clearance_r, h=probemount_outer_h+0.02);
      }
      translate([-1.7*probemount_r,-probemount_r,wall_w])
      {
        cube([2*probemount_r,2*probemount_r,probemount_outer_h]);
      }
    }
    // Cutout for bolt through hole
    translate([0,0,-0.01])
    {
      cylinder(r=m6_cutout_r, h=wall_w+0.02, $fs=0.05);
    }
    // Cutout for swiwel space for the flatpiece
    translate([-0.01,-(probemount_r-2*wall_w)/2,probemount_outer_h-flatpiece_wdh[2]-2*wall_w])
    {
      cube([probemount_r,probemount_r-2*wall_w,probemount_outer_h-2*wall_w]);
    }
    // Cutout for cable exit for fixed nut
    translate([-0.01,-(probemount_r-2*wall_w)/2,wall_w])
    {
      cube([probemount_r+springmount_extension,probemount_r-2*wall_w,cable_exit_height]);
    }
    // cutout for the spring mount movement
    translate([springmount_extension,0,springmount_height])
    {
      rotate([0,max_expected_flatpiece_rotation_travel,0])
      {
        rotate([0,-90,0])
        {
          // Clearing for spring to move freely
          cylinder(r=spring_free_rotation_clearing_r,h=2*probemount_r,$fs=1);
          mirror([0,0,1])
          {
            // Clearing for M3 nut
            translate([0,0,-0.01])
            {
              cylinder(r=m3_nut_width_fn6_cutout_r,h=wall_w+0.02,$fn=6);
            }
            // Clearing for M3 bolt
            translate([0,0,wall_w])
            {
              cylinder(r=m3_radius_for_cutaway,h=wall_w+0.02,$fs=0.5);
            }
            // Clearing for opposing side mounting
            translate([0,0,wall_w+wall_w])
            {
              cylinder(r=springmount_radius-wall_w,h=2*probemount_r,$fs=1);
            }
            translate([-springmount_radius,-springmount_radius,wall_w+wall_w])
            {
              cube([probemount_outer_h,2*springmount_radius,2*springmount_radius]);
            }
          }
        }
      }
    }
    // Cutout for rotation pin
    translate([0,0,rotation_pin_height])
    {
      rotate([90,0,0])
      {
        translate([rotation_pin_horiz_offset,0,-probemount_r])
        {
          cylinder(r=rotation_pin_cutout_r, h=2*probemount_r, $fs=0.05);
        }
      }
    }
  }
  // Visualisation of rotating flat piece
  %
  translate([0,0,rotation_pin_height])
  {
    rotate([90,0,0])
    {
      translate([rotation_pin_horiz_offset-flatpiece_wdh[1]/2,0,-flatpiece_wdh[0]/2])
      {
        for (rot = flatpiece_rot_minmax)
        {
          rotate([0,0,rot])
          {
            cube([flatpiece_wdh[2],flatpiece_wdh[1],flatpiece_wdh[0]]);
          }
        }
      }
    }
  }
  // Visualisation of probe touch bolt
  %
  union() {
    cylinder(r=3,h=wall_w+25);
    for (zoff = [wall_w,wall_w+wall_w+25-2])
    {
      translate([0,0,zoff])
      {
        cylinder(r=m6_nut_fn6_r-0.5,h=2,$fn=6);
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
  probemount();
} else if ("probemount" == partname)
{
  probemount();
}
