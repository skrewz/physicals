// Use partname to control which object is being rendered:
//
// _partname_values doorstop
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

// From the floor, radii and height of the floor pole:
floor_mount_cutout_rrh = [(13.89+0.1)/2,(12.82+0.1)/2,28.11];

doorstop_cylinder_rh = [40/2,25];
inside_height_offset = 8;
wall_w = 2;
magnet_distancing = 1.0;
magnet_cutout_rh = [(20+0.3)/2,4*3+0.3];

module doorstop()
{
  difference()
  {
    // The round/cubical main body of doorstop():
    union()
    {
      cylinder(r=doorstop_cylinder_rh[0], h=doorstop_cylinder_rh[1]);
      translate([-doorstop_cylinder_rh[0],0,0])
      {
        cube([2*doorstop_cylinder_rh[0],doorstop_cylinder_rh[0],doorstop_cylinder_rh[1]]);
      }
    }

    // The cutout for the inner floor_mount_cutout_rrh post:
    translate([0,0,-0.01])
    {
      cylinder(r=max(floor_mount_cutout_rrh[0],floor_mount_cutout_rrh[1]), h=doorstop_cylinder_rh[1]-wall_w-inside_height_offset);
    }

    // The cutout for the inner floor_mount_cutout_rrh post:
    translate([0,doorstop_cylinder_rh[0]-magnet_distancing,magnet_cutout_rh[0]+magnet_distancing])
    {
      mirror([0,1,0])
      {
        #
        union()
        {
          translate([-magnet_cutout_rh[0],0,0])
          {
            // This is dimensioned to reach almost to the top so as to allow
            // bridging and spacing above the slotted-in magnet:
            cube([2*magnet_cutout_rh[0],magnet_cutout_rh[1],doorstop_cylinder_rh[1]-2*magnet_distancing-magnet_cutout_rh[0]]);
          }
          rotate([-90,0,0])
          {
            cylinder(r=magnet_cutout_rh[0], h=magnet_cutout_rh[1]);
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
  doorstop();
} else if ("doorstop" == partname)
{
  doorstop();
}
