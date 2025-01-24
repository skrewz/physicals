// Use partname to control which object is being rendered:
//
// _partname_values extender
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

wall_w = 1.4; 
bottom_w = 2;

// The height that this device should add:
extension_length = 50;
// The height onto the leg that the device should "grab":
attachment_length = 60;

shelf_beam_cutout_wd = [16.3,16.3];
// how much of a beam to grab onto:
shelf_beam_grab_length = 60;
shelf_beam_lip_size = 1.5;

module extender()
{
  difference()
  {
    union()
    {
      cube([shelf_beam_cutout_wd[0]+2*wall_w,shelf_beam_cutout_wd[1]+2*wall_w,extension_length]);
      translate([0,0,extension_length])
      {
        hull()
        {
          cube([shelf_beam_cutout_wd[0]+2*wall_w,shelf_beam_cutout_wd[1]+2*wall_w,0.01]);
          translate([wall_w,wall_w,attachment_length])
          {
            cube([shelf_beam_cutout_wd[0]+1*wall_w,shelf_beam_cutout_wd[1]+1*wall_w,0.01]);
          }
        }
      }
    }

    translate([wall_w,wall_w,extension_length-0.01])
    {
      cube([shelf_beam_cutout_wd[0],shelf_beam_cutout_wd[1],extension_length+attachment_length]);
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
  extender();
} else if ("extender" == partname)
{
  extender();
}
