// Use partname to control which object is being rendered:
//
// _partname_values button_protector
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

mount_height = 40;
mount_depth = 70;

chassis_front_w = 205;
chassis_front_cutout_wd = [chassis_front_w,mount_depth] + [1.0, 0.0];
wall_w = 1;

// These cutouts (symmetric around the power button provide access to audio
// jacks (😀) and USB outlets:
plug_cutout_wd = [55, 20];
plug_cutout_offset_from_front = 10;
// This leaves a 20mm wide cover on top of the power button (which is arguably
// the whole reason you're reading this):
plug_cutout_offset_from_centre = 10;

// middle: 

// 2cm wide strip

// cutout: 2cm deep, 1cm from front
module button_protector()
{
  difference()
  {
    cube ([chassis_front_cutout_wd[0]+2*wall_w,chassis_front_cutout_wd[1]+wall_w,mount_height]);
    translate([wall_w,-0.01,-wall_w])
    {
      cube ([chassis_front_cutout_wd[0],chassis_front_cutout_wd[1],mount_height]);
    }

    translate([wall_w+chassis_front_cutout_wd[0]/2,(mount_depth+wall_w-wall_w)-plug_cutout_offset_from_front-plug_cutout_wd[1],mount_height-wall_w-0.01])
    {
      for (m = [0,1])
      {
        mirror([m,0,0])
        {
          translate([plug_cutout_offset_from_centre,0,0])
          {
            cube([plug_cutout_wd[0],plug_cutout_wd[1],wall_w+0.02]);
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
  button_protector();
} else if ("button_protector" == partname)
{
  rotate([0,180,0])
  {
    button_protector();
  }
}
