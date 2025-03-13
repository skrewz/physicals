// Use partname to control which object is being rendered:
//
// _partname_values foot clasp
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

rod_r = 32/2;
foot_rod_cutout_r = 1.0*rod_r;
clasp_rod_cutout_r = 0.95*rod_r;

wall_w = 1;

foot_rod_grab_length = 40;

clasp_grab_length = 10;
clasp_grab_band_width = 0.4;
clasp_hook_r = 4;


module foot()
{
  difference()
  {
    union()
    {
      sphere(r=foot_rod_cutout_r+wall_w);
      cylinder(r=foot_rod_cutout_r+wall_w, h=foot_rod_grab_length);
    }
    cylinder(r=foot_rod_cutout_r, h=foot_rod_grab_length+0.01);
  }
}

module clasp()
{
  difference()
  {
    union()
    {
      cylinder(r=clasp_rod_cutout_r+clasp_grab_band_width, h=clasp_grab_length);
      translate([0,0,clasp_hook_r])
      {
        rotate([90,0,0])
        {
          cylinder(r=clasp_hook_r, h=clasp_rod_cutout_r+clasp_hook_r);
        }
      }
    }
    translate([0,0,-0.01])
    {
      cylinder(r=clasp_rod_cutout_r, h=clasp_grab_length+0.02);
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
  foot();

  translate([0,0,100])
  {
    clasp();
  }
  translate([0,0,200])
  {
    rotate([180,0,0])
    {
      foot();
    }
  }
} else if ("clasp" == partname)
{
  clasp();
} else if ("foot" == partname)
{
  rotate([180,0,0])
  {
    foot();
  }
}
