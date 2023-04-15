// Use partname to control which object is being rendered:
//
// _partname_values pass_through
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

mount_wh = [80,80];
mount_rounding_r = 3;
mount_nut_inset = [4.25, 4.25];
mount_nut_cutout_r = 1.5+0.3;

hose_cutout_r = 42.5/2+1;
hose_cutout_length = 60;
hose_cutout_angle = 60;

wall_w = 3;


module pass_through_pos()
{

  // The base plate:
  translate([mount_rounding_r, mount_rounding_r, 0])
  {
    minkowski()
    {
      cube([mount_wh[0]-2*mount_rounding_r, mount_wh[1]-2*mount_rounding_r, wall_w]);
      cylinder(r=mount_rounding_r, h=0.01, $fs = 0.5);
    }
  }

  // The cylinder including walls:
  translate([mount_wh[0]/2, mount_wh[1]/2,0])
  {
    rotate([0,-hose_cutout_angle,0])
    {
      translate([0,0,-hose_cutout_length])
      {
        cylinder(r=hose_cutout_r+wall_w, h=2*hose_cutout_length);
      }
    }
  }
}

module pass_through_neg()
{
  // Cut-out of whatever's beneath XY plane:
  translate([-mount_wh[0], -mount_wh[1],0])
  {
    mirror([0,0,1])
    {
      cube([3*mount_wh[0], 3*mount_wh[1],max(hose_cutout_r,2*hose_cutout_length)]);
    }
  }

  // Cut-through of the hose holder:
  translate([mount_wh[0]/2, mount_wh[1]/2,0])
  {
    rotate([0,-hose_cutout_angle,0])
    {
      translate([0,0,-hose_cutout_length-0.01])
      {
        cylinder(r=hose_cutout_r, h=2*hose_cutout_length+0.02);
      }
    }
  }

  // Cut-out for the mounting holes:
  for (xoff = [mount_nut_inset[0],mount_wh[0]-mount_nut_inset[0]])
  {
    for (yoff = [mount_nut_inset[1],mount_wh[1]-mount_nut_inset[1]])
    {
      translate([xoff, yoff, -0.01])
      {
        cylinder(r=mount_nut_cutout_r, h=wall_w+0.03, $fs=0.9);
      }
    }
  }
}

module pass_through()
{
  difference()
  {
    pass_through_pos();
    pass_through_neg();
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
  pass_through();
} else if ("pass_through" == partname)
{
  pass_through();
}
