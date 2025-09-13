// Use partname to control which object is being rendered:
//
// _partname_values fob_holder
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

keyfob_rh = [25/2,1.2];
keyring_cutout_r = 1.5;

keyfob_cutout_rh = [keyfob_rh[0]+0.5,keyfob_rh[1]+0.4];
wall_wh = [1,0.5];

module fob_holder()
{
  other_cutthrouh_xyz = [keyfob_cutout_rh[0]+wall_wh[0]+keyring_cutout_r,0,0];
  difference()
  {
    // Main body of fob_holder():
    hull()
    {
      cylinder(r=keyfob_cutout_rh[0]+wall_wh[0], h=keyfob_cutout_rh[1]+2*wall_wh[1]);
      translate(other_cutthrouh_xyz)
      {
        cylinder(r=keyring_cutout_r+wall_wh[0],h=keyfob_cutout_rh[1]+2*wall_wh[1]);
      }
    }
    // Empty space for the fob itself
    translate([0,0,wall_wh[1]])
    {
      cylinder(r=keyfob_cutout_rh[0],h=keyfob_cutout_rh[1]);
    }
    // Cutthrough for the key ring hole:
    translate(other_cutthrouh_xyz)
    {
      translate([0,0,-0.01])
      {
        cylinder(r=keyring_cutout_r,h=0.02+keyfob_cutout_rh[1]+2*wall_wh[1]);
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
  fob_holder();
} else if ("fob_holder" == partname)
{
  fob_holder();
}
