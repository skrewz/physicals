// Use partname to control which object is being rendered:
//
// _partname_values adapter
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

dust_shoe_cutout_radius = (37.7/2)+0.5;
dust_shoe_connector_length = 34.7-0;

vacuum_hose_cutout_radius = (42.8/2)+0.5;
vacuum_hose_connector_length = 30.4+8;

motor_mount_outer_radius = 64.45 /* measured *//2;

greater_radius = max(dust_shoe_cutout_radius, vacuum_hose_cutout_radius);

// between the two radiuses of the dust shoe
// https://www.sainsmart.com/products/cnc-dust-shoe-abs-cover-cleaner-for-52mm-spindle-motor has measurements of the holes' diameters:
dust_shoe_radial_distance = 96.65 /* measured */ - 32/2 - 52/2;

wall_w = 2;
safety_glasses_holder_rh = [11/2,40];


module adapter()
{
  // Helper module for inner-cylinder-radius-wall_w cylinders:
  module cyl (r,h,w=wall_w)
  {
    difference() {
      cylinder(r=r+w, h=h);
      translate([0,0,-0.01])
        cylinder(r=r, h=h+0.02);
    }
  }

  difference()
  {
    union()
    {
      // Safety glasses holder
      rotate([0,0,-120])
      {
        translate([greater_radius+safety_glasses_holder_rh[0]+wall_w,0,0])
        {
          cyl(safety_glasses_holder_rh[0],safety_glasses_holder_rh[1]);
        }
      }

      // Dust shoe holder
      cyl(dust_shoe_cutout_radius, dust_shoe_connector_length, w=vacuum_hose_cutout_radius-dust_shoe_cutout_radius+wall_w);

      // The vacuum hose attachment end:
      translate([0,0,dust_shoe_connector_length])
      {
        cyl(vacuum_hose_cutout_radius, vacuum_hose_connector_length);
      }
    }
    // A cutout for the spindle motor holder (it gets a bit tight):
    translate([dust_shoe_radial_distance,0,-0.01])
    {
      cylinder(r=motor_mount_outer_radius,h=vacuum_hose_connector_length+dust_shoe_connector_length+0.02);
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
  adapter();
} else if ("adapter" == partname)
{
  adapter();
}
